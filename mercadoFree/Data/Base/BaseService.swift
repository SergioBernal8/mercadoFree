//
//  BaseService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 18/05/21.
//

import Foundation

protocol BaseService {
    func printError(with error: NetworkErrorResponse)
    func printResponse<T>(response: T)
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum NetworkErrorResponse: LocalizedError {
    case error2xx(code: Int)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case requestTimeout
    case error4xx(code: Int)
    case serverError
    case notImplemented
    case badGateway
    case gatewayTimeout
    case error5xx(code: Int)
    case unableToParseResponse
    case unableToMakeRequest
    case invalidHttpResponse
    case notNetworkErrorResponse
    case decodingError
    case unknown
}

extension NetworkErrorResponse {
    var errorDescription: String? {
        switch self {
        case .error2xx(let code),.error4xx(let code),.error5xx(let code) :
            return "Error \(code)"
        case .badRequest:
            return "badRequest"
        case .unauthorized:
            return "unauthorized"
        case .forbidden:
            return "forbidden"
        case .notFound:
            return "notFound"
        case .requestTimeout:
            return "requestTimeout"
        case .serverError:
            return "serverError"
        case .notImplemented:
            return "notImplemented"
        case .badGateway:
            return "badGateway"
        case .gatewayTimeout:
            return "gatewayTimeout"
        case .unableToParseResponse:
            return "unableToParseResponse"
        case .unableToMakeRequest:
            return "unableToMakeRequest"
        case .invalidHttpResponse:
            return "invalidHttpResponse"
        case .notNetworkErrorResponse:
            return "notNetworkErrorResponse"
        case .decodingError:
            return "decodingError"
        case .unknown:
            return "unknown"
        }
    }
    
    var failureReason: String?{
        switch self {
        case .error2xx(let code),.error4xx(let code),.error5xx(let code) :
            return "\(code)"
        case .badRequest:
            return "400"
        case .unauthorized:
            return "401"
        case .forbidden:
            return "403"
        case .notFound:
            return "404"
        case .requestTimeout:
            return "408"
        case .serverError:
            return "500"
        case .notImplemented:
            return "501"
        case .badGateway:
            return "502"
        case .gatewayTimeout:
            return "504"
        default:
            return ""
        }
    }
}
