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

enum NetworkErrorResponse: LocalizedError, Equatable {
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
    case unknown
}
