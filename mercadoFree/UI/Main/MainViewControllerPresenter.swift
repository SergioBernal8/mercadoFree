//
//  MainViewControllerPresenter.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 23/05/21.
//

import Foundation
import Combine

protocol MainViewControllerPresenterInterface {
    func getProductsForQuery(query: String)
    func getNextProducts()
    func getProductCount() -> Int
    func getProduct(for index: Int) -> ProductForCell
}

class MainViewControllerPresenter: MainViewControllerPresenterInterface {
            
    weak var viewInterface: MainViewControllerInterface?
    private var productRepository: ProductRepository
    private var allProducts = [ProductForCell]()
    
    var cancellables = [AnyCancellable]()
    
    init(viewInterface: MainViewControllerInterface?, productRepository: ProductRepository) {
        self.viewInterface = viewInterface
        self.productRepository = productRepository
    }
    
    func makeProductsRequest(for query: String) {
        
        self.viewInterface?.displayLoadingIndicator()
        productRepository.getProducts(for: query).receive(on: DispatchQueue.main)
            .sink { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case.finished :
                self.viewInterface?.hideLoadingIndicator(completion: nil)
                break
            case .failure(let error):
                Logger.shared.log(from: self, message: "\(error.failureReason ?? "") - \(error.localizedDescription) ")
                var errorCode = ""
                if !(error.failureReason ?? "").isEmpty {
                    errorCode = "\nFailed with error: \(errorCode)"
                }
                let message = "We can't proccess your request right now." + errorCode
                self.viewInterface?.displayErrorAlert(with: message)
            }
        } receiveValue: { products in
            self.allProducts.append(contentsOf: products.map{ ProductForCell(productWithImage: $0) })
            self.viewInterface?.displayProducts()
        }.store(in: &cancellables)
    }
}

// MARK: MainViewControllerPresenterInterface

extension MainViewControllerPresenter {
    
    
    func getNextProducts() {
        makeProductsRequest(for: "")
    }
    
    func getProductsForQuery(query: String) {
        guard !query.isEmpty, !query.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            self.viewInterface?.displayErrorAlert(with: "Query must no be empty")
            return
        }
        self.allProducts.removeAll()
        makeProductsRequest(for: query)
    }
    
    func getProductCount() -> Int { allProducts.count }
    
    func getProduct(for index: Int) -> ProductForCell { allProducts[index] }
}
