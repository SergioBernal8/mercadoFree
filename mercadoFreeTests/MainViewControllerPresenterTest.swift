//
//  MainViewControllerPresenterTest.swift
//  mercadoFreeTests
//
//  Created by Sergio Bernal on 25/05/21.
//

import XCTest
@testable import mercadoFree

class MainViewControllerPresenterTest: XCTestCase {
    
    var presenter: MainViewControllerPresenter?
    var mockRepo: MockProductService?

    override func setUp() {
        mockRepo = MockProductService()
        if let mockRepo = mockRepo {
            presenter = MainViewControllerPresenter(viewInterface: nil, productRepository: mockRepo)
        }
    }
    
    
    func testNotEmptyResponse() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(mockRepo)
        
        let expectation = expectation(description: "testNotEmptyResponse")
        presenter?.getProductsForQuery(query: "some query")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
                        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(presenter?.getProductCount() ?? 0 > 0)
        XCTAssertTrue(presenter?.getProduct(for: 0) != nil)
    }
    
    func testPagingResponse() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(mockRepo)
        
        let expectation = expectation(description: "testyResponse")
        presenter?.getProductsForQuery(query: "some query")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.getNextProducts()
        }
                        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
                        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(presenter?.getProductCount() ?? 0 > 0)
    }
    
    func testEmptyResponse() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(mockRepo)
        
        mockRepo?.mockCase = .empty
        
        let expectation = expectation(description: "testEmptyResponse")
        presenter?.getProductsForQuery(query: "")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
                        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(presenter?.getProductCount() ?? 0 == 0)
    }
    
    func testErrorResponse() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(mockRepo)
        
        mockRepo?.mockCase = .fail
        
        let expectation = expectation(description: "testEmptyResponse")
        presenter?.getProductsForQuery(query: "some query")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
                        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(presenter?.getProductCount() ?? 0 == 0)
    }
    
}
