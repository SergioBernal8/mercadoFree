//
//  ProductRepository.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 19/05/21.
//

import Foundation
import Combine

protocol ProductRepository {
    
    func getProducts(for query: String) -> AnyPublisher<[ProductWithImage], NetworkErrorResponse>
}
