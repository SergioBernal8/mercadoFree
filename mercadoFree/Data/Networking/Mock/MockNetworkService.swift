//
//  MockNetworkService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 21/05/21.
//

import Foundation
import Combine

enum NetworkMockCase {
    case success
    case fail
}

class MockNetworkService: Networking {
       
    func performRequest<T>(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<T, NetworkErrorResponse> where T : Decodable, T : Encodable {
        let mockJson = """
            {
            }
            """
        if let data = mockJson.data(using: .utf8), let jsonData = try? JSONDecoder().decode(T.self, from: data) {
            printResponse(response: data)
            return Just(jsonData).setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
        }
        return Empty.init(completeImmediately: true).eraseToAnyPublisher()
    }
    
    func performRequestData(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<Data, NetworkErrorResponse> {
        return Just(Data()).setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
    }
    
    func printError(with error: NetworkErrorResponse) {}
    
    func printResponse<T>(response: T) {
        Logger.shared.log(from: self, with: .debug, message: "Data: \(response)")
    }
}
