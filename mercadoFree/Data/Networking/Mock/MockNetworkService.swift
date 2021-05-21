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
    
    var mockCase = NetworkMockCase.success
    
    func performRequest<T>(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<T, NetworkErrorResponse> where T : Decodable, T : Encodable {
        if mockCase == .success {
            let mockJson = """
                {
                }
                """            
            if let data = mockJson.data(using: .utf8),  let jsonData = try? JSONDecoder().decode(T.self, from: data) {
                return Just(jsonData).setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
            }
        }
        return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
    }
    
    func performRequestData(url: URL, method: HTTPMethod, parameters: [String : String]?, headers: [String : String]?) -> AnyPublisher<Data, NetworkErrorResponse> {
        if mockCase == .success {
            return Just(Data()).setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
        } else {
            return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
        }
    }
    
    func printError(with error: NetworkErrorResponse) {
        Logger.shared.log(from: self, with: .debug, message: "\(error.failureReason ?? "") - \(error.localizedDescription)")
    }
    
    func printResponse<T>(response: T) {
        Logger.shared.log(from: self, with: .debug, message: "Data: \(response)")
    }
}
