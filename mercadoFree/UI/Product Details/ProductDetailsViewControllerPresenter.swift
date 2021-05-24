//
//  ProductDetailsViewControllerPresenter.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 24/05/21.
//

import Foundation

protocol ProductDetailsViewControllerPresenterInterface {
    func mapProductValues(for product: ProductForCell)
    func getProductDetailsCount() -> Int
    func getProductDetail(for index: Int) -> String
}

class ProductDetailsViewControllerPresenter: ProductDetailsViewControllerPresenterInterface {
               
    var productDetailsData = [String]()
    
    weak var viewInterface: ProductDetailsViewControllerInterface?
    
    init(viewInterface: ProductDetailsViewControllerInterface?) {
        self.viewInterface = viewInterface
    }
    
    func mapProductValues(for product: ProductForCell) {
        let title = product.productWithImage.product.title
        let price = product.formattedPrice
        let installments = product.installmentText
        let quntity = product.quantity
        let condition = product.condition
        
        productDetailsData.append(title)
        productDetailsData.append(price)
        productDetailsData.append(installments)
        productDetailsData.append(quntity)
        productDetailsData.append(condition)
        
        viewInterface?.reloadData()
    }
    
    func getProductDetailsCount() -> Int { productDetailsData.count }
    
    func getProductDetail(for index: Int) -> String { productDetailsData[index] }
}
