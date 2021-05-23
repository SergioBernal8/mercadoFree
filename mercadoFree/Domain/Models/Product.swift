//
//  Product.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 19/05/21.
//

import Foundation


struct Product: Codable {
    let id: String
    let title: String
    let price: Double
    let prices: Prices?
    let availableQuantity: Double
    let soldQuantity: Double
    let condition: String
    let thumbnail: String
    let acceptsMercadopago: Bool
    let installments: Installments
    
    struct Prices: Codable {
        let prices: [Price]?
        
        init()  {
            self.prices = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case prices
        case availableQuantity = "available_quantity"
        case soldQuantity = "sold_quantity"
        case condition        
        case thumbnail
        case acceptsMercadopago = "accepts_mercadopago"
        case installments
    }
    
    init(with id: String, thumbnail: String) {
        self.id = id
        self.title = "Title"
        self.price = 2000
        self.prices = Prices()
        self.availableQuantity = 10
        self.soldQuantity = 1
        self.condition = "New"
        self.thumbnail = thumbnail
        self.acceptsMercadopago = true
        self.installments = Installments()
    }
}
