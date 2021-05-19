//
//  NetworkService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 18/05/21.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

protocol Networking: BaseService {
    func performRequest<T: Codable>(url: URL, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?) -> AnyPublisher<T, NetworkErrorResponse>
}

class NetworkService: Networking {
    
    func performRequest<T>(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<T, NetworkErrorResponse> where T : Decodable, T : Encodable {
        
        var urlComponent = URLComponents(string: url.absoluteString)
        
        if let parameters = parameters {
            parameters.forEach { (key, value) in
                urlComponent?.queryItems?.append(URLQueryItem(name: key, value: value))
            }
        }
        
        guard let urlWithParams = urlComponent?.url else { return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher() }
        
        var request = URLRequest(url: urlWithParams)
        request.httpMethod = method.rawValue
        if let headers = headers {
            headers.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
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
            .decode(type: T.self, decoder: JSONDecoder())
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
    
    func printError(with error: NetworkErrorResponse) {
        Logger.shared.log(from: self, with: .error, message: "\(error.localizedDescription) :: \(error.errorDescription ?? "")")
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
