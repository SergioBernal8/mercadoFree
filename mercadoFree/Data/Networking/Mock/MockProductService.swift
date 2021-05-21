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
        if mockCase == .success {
            guard let url = URL(string: APIConstants.baseUrl) else { return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher() }
            
            let anyPublisher: AnyPublisher<MockObject, NetworkErrorResponse> = service.performRequest(url: url, method: HTTPMethod.get, parameters: ["q": query], headers: ["":""])
            
            let newPublisher = anyPublisher.map { product -> [Product] in
                let array = 1...4
                return array.map { Product(with: "\($0)", thumbnail: "http://http2.mlstatic.com/D_821010-MLA44514977798_012021-I.jpg") }
            }.flatMap { products in
                products.publisher.setFailureType(to: NetworkErrorResponse.self)
            }.flatMap { product -> AnyPublisher<ProductWithImage, NetworkErrorResponse> in
                guard let url = URL(string: product.thumbnail) else {
                    Logger.shared.log(from: self, with: .error, message: "Unable to make request")
                    return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
                }
                return self.service.performRequestData(url: url, method: HTTPMethod.get, parameters: nil, headers: nil).map { data in
                    let productWithImage = ProductWithImage(product: product, image: Data())
                    return productWithImage
                }.eraseToAnyPublisher()
            }.collect()
            return newPublisher.eraseToAnyPublisher()
        } else if mockCase == .empty {
            return Empty().setFailureType(to: NetworkErrorResponse.self).eraseToAnyPublisher()
        }
        else {            
            return Fail.init(error: NetworkErrorResponse.badRequest).eraseToAnyPublisher()
        }
    }
}
