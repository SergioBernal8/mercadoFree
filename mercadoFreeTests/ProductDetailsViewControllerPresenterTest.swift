//
//  ProductDetailsViewControllerPresenterTest.swift
//  mercadoFreeTests
//
//  Created by Sergio Bernal on 25/05/21.
//

import XCTest
@testable import mercadoFree

class ProductDetailsViewControllerPresenterTest: XCTestCase {
        
    var data: ProductForCell?
    var presenter: ProductDetailsViewControllerPresenter?
    
    override func setUp() {
        let product = Product(with: "id", thumbnail: APIConstants.baseUrl)
        let productWithImage = ProductWithImage(product: product, image: Data())
        self.data = ProductForCell(productWithImage: productWithImage)
        self.presenter = ProductDetailsViewControllerPresenter(viewInterface: nil)
    }
        
    
    func testMapGetProductsNotEmpty() {
        XCTAssertNotNil(presenter)
        if let data = data {
            presenter?.mapProductValues(for: data)
        }
        XCTAssertTrue(presenter?.getProductDetailsCount() ?? 0 > 0)
    }
    
    func testGetProductsDetail() {
        XCTAssertNotNil(presenter)
        if let data = data {
            presenter?.mapProductValues(for: data)
        }
        for i in 0..<(presenter?.getProductDetailsCount() ?? 0){
            XCTAssertTrue(!(presenter?.getProductDetail(for: i) ?? "").isEmpty)
        }
    }
}
