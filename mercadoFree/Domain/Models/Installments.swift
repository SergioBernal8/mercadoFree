//
//  installments.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 19/05/21.
//

import Foundation

struct Installments: Codable {
    let quantity: Int
    let amount: Double
    let rate: Int
    
    init() {
        self.quantity = 36
        self.amount = 1
        self.rate = 1
    }
}
