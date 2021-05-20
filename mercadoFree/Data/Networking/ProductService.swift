//
//  ProductService.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 20/05/21.
//

import Foundation
import Combine

class ProductService: ProductRepository {
    
    private let service: NetworkService
    
    init() {
        self.service = NetworkService()
    }
    
    func getProducts(for query: String) -> AnyPublisher<[ProductWithImage], NetworkErrorResponse> {
        guard let url = URL(string: APIConstants.baseUrl + APIConstants.queryPath) else {
            Logger.shared.log(from: self, with: .error, message: "Unable to make request")
            return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
        }
        let anyPublisher: AnyPublisher<Results, NetworkErrorResponse> = service.performRequest(url: url, method: HTTPMethod.get, parameters: ["q" : query], headers: nil)
        
        
        let newPublisher = anyPublisher.map { results in
            results.results
        }.flatMap { products in
            products.publisher.setFailureType(to: NetworkErrorResponse.self)
        }.flatMap { product -> AnyPublisher<ProductWithImage, NetworkErrorResponse>  in
            guard let url = URL(string: product.thumbnail) else {
                Logger.shared.log(from: self, with: .error, message: "Unable to make request")
                return Fail.init(error: NetworkErrorResponse.unableToMakeRequest).eraseToAnyPublisher()
            }
            return self.service.performRequestData(url: url, method: HTTPMethod.get ,parameters: nil, headers: nil).map { data -> ProductWithImage in
                let productWithImage = ProductWithImage(product: product, image: data)
                return productWithImage
            }.eraseToAnyPublisher()
            
        }.collect()
        
        return newPublisher.eraseToAnyPublisher()
    }
}
