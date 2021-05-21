//
//  NetworkingTest.swift
//  mercadoFreeTests
//
//  Created by Sergio Bernal on 21/05/21.
//

import XCTest
import Combine

@testable import mercadoFree


class NetworkingTest: XCTestCase {
    
    private var cancellables = [AnyCancellable]()
    
    func testEmptyResponse() {
        
        let mockService = MockProductService()
        
        let expectations = expectation(description: "Empty response")
        
        mockService.mockCase = .empty
        
        var productsData = [ProductWithImage]()
        
        mockService.getProducts(for: "query").sink { response in
            switch response{
            case.finished:
                break
            case .failure:
                break
            }
            expectations.fulfill()
        } receiveValue: { products in
            productsData = products
        }.store(in: &cancellables)
        
        XCTAssertTrue(productsData.isEmpty,"Products not empty")
        
        wait(for: [expectations], timeout: 2)
    }
    
    func testSuccessResponse() {
        
        let mockService = MockProductService()
        
        let expectations = expectation(description: "Not empty response")
        
        mockService.mockCase = .success
        
        var productsData = [ProductWithImage]()
        
        mockService.getProducts(for: "query").sink { response in            
            switch response{
            case.finished:
                break
            case .failure:
                break
            }
            expectations.fulfill()
        } receiveValue: { products in
            productsData = products
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(!productsData.isEmpty,"Products empty")
    }
    
    func testErrorResponse() {
        
        let mockService = MockProductService()
        
        let expectations = expectation(description: "Not empty response")
        
        mockService.mockCase = .fail
                        
        mockService.getProducts(for: "query").sink { response in
            switch response{
            case.finished:
                break
            case .failure(let error):
                XCTAssertTrue(error == NetworkErrorResponse.badRequest)
                break
            }
            expectations.fulfill()
        } receiveValue: { products in
            XCTAssertTrue(products.isEmpty)
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 3, handler: nil)
        
    }
}
