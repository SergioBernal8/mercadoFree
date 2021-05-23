//
//  NetworkService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 18/05/21.
//

import Foundation
import Combine


protocol Networking: BaseService {
    func performRequest<T>(url: URL, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?) -> AnyPublisher<T, NetworkErrorResponse> where T : Decodable, T : Encodable
    func performRequestData(url: URL, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?) -> AnyPublisher<Data, NetworkErrorResponse>
}

class NetworkService: Networking {
    
    func performRequestData(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<Data, NetworkErrorResponse> {
        
        guard let request = getUrlRequest(url: url, method: method, parameters: parameters, headers: headers) else {
            let error = NetworkErrorResponse.unableToMakeRequest
            self.printError(with: error)
            return Fail.init(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let response = element.response as? HTTPURLResponse else {
                    let error = NetworkErrorResponse.invalidHttpResponse
                    self.printError(with: error)
                    throw error
                }
                guard response.statusCode == 200 else {
                    let error = self.handleErrorResponse(withCode: response.statusCode)
                    self.printError(with: error)
                    throw error
                }
                return element.data
            }
            .mapError({ error in
                switch error {
                case let error as NetworkErrorResponse:
                    return error
                default:
                    return NetworkErrorResponse.notNetworkErrorResponse
                }
            })
            .eraseToAnyPublisher()
    }
    
    func performRequest<T>(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<T, NetworkErrorResponse> where T : Decodable, T : Encodable {
        
        guard let request = getUrlRequest(url: url, method: method, parameters: parameters, headers: headers) else {
            let error = NetworkErrorResponse.unableToMakeRequest
            self.printError(with: error)
            return Fail.init(error: error).eraseToAnyPublisher()
        }
        Logger.shared.log(from: self, with:.debug, message: "Making request to \(request.url?.absoluteString ?? "")")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
                
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap( { data, response  in                            
                guard let response = response as? HTTPURLResponse else {
                    let error = NetworkErrorResponse.invalidHttpResponse
                    self.printError(with: error)
                    throw error
                }
                guard response.statusCode == 200 else {
                    let error = self.handleErrorResponse(withCode: response.statusCode)
                    self.printError(with: error)
                    throw error
                }
                self.printResponse(response: data)
                return data
            })
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError({ error in
                switch error {
                case let error as Swift.DecodingError:                    
                    self.printError(with: error)
                    return NetworkErrorResponse.decodingError
                case let error as NetworkErrorResponse:
                    return error
                default:
                    return NetworkErrorResponse.notNetworkErrorResponse
                }
            })
            .eraseToAnyPublisher()
    }
    
    func getUrlRequest(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> URLRequest? {
        var urlComponent = URLComponents(string: url.absoluteString)
        
        if let parameters = parameters {
            parameters.forEach { (key, value) in
                urlComponent?.queryItems?.append(URLQueryItem(name: key, value: value))
            }
        }
    
        guard let urlWithParams = urlComponent?.url else { return nil }
        
        var request = URLRequest(url: urlWithParams)
        request.httpMethod = method.rawValue
        if let headers = headers {
            headers.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    func printError(with error: NetworkErrorResponse) {
        Logger.shared.log(from: self, with: .error, message: "\(error.failureReason ?? "") - \(error.localizedDescription)")
    }
    
    func printError(with error: DecodingError) {
        Logger.shared.log(from: self, with: .error, message: "\(error.localizedDescription)")
    }
    
    func printResponse<T>(response: T) {
        Logger.shared.log(from: self, with: .network, message: "Data: \(response)")
    }
}

// MARK: Error Handling

extension NetworkService {
    
    func handleErrorResponse(withCode errorCode: Int) -> NetworkErrorResponse {
        switch errorCode {
        case 201...299:
            return .error2xx(code: errorCode)
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 408:
            return .requestTimeout
        case 405, 406, 407, 409...499:
            return .error4xx(code: errorCode)
        case 500:
            return .serverError
        case 501:
            return .notImplemented
        case 502:
            return .badGateway
        case 504:
            return .gatewayTimeout
        case 505...511:
            return .error5xx(code: errorCode)
        default:
            return .unknown
        }
    }
}
