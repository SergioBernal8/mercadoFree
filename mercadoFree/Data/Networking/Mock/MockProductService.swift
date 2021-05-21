//
//  MockProductService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 21/05/21.
//

import Foundation
import Combine

enum MockProductCase {
    case success
    case empty
    case fail
}

class MockProductService: ProductRepository {
    
    private let service: Networking
    var mockCase = MockProductCase.success
    
    init() {
        self.service = MockNetworkService()
    }
    
    func getProducts(for query: String) -> AnyPublisher<[ProductWithImage], NetworkErrorResponse> {
        guard let mockService = service as? MockNetworkService else {
            return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
        }
        if mockCase != .fail {
            mockService.mockCase = .success
            guard let url = URL(string: APIConstants.baseUrl) else { return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher() }
            
            let anyPublisher: AnyPublisher<MockObject, NetworkErrorResponse> = service.performRequest(url: url, method: HTTPMethod.get, parameters: ["q": query], headers: ["":""])
            
            let newPublisher = anyPublisher.map { product -> [Product] in
                if self.mockCase == .success {
                    let array = 1...4
                    return array.map { Product(with: "\($0)") }
                }
                let emptyArray = [Product]()
                return emptyArray
            }.flatMap { products in
                products.publisher.setFailureType(to: NetworkErrorResponse.self)
            }.flatMap { product -> AnyPublisher<ProductWithImage, NetworkErrorResponse> in
                if self.mockCase == .empty {
                    return Empty().setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
                } else {
                    let productWithImage = ProductWithImage(product: product, image: Data())
                    return Just(productWithImage).setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
                }
            }.collect()
            return newPublisher.eraseToAnyPublisher()
        }
        else {
            mockService.mockCase = .fail
            return Fail.init(error: NetworkErrorResponse.badRequest).eraseToAnyPublisher()
        }
    }
}
