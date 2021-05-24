//
//  ProductForCell.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 23/05/21.
//

import Foundation


struct ProductForCell {
    let productWithImage: ProductWithImage
    
    var formattedPrice: String {
        get {
            guard let fomatted = getFormatter().string(from: productWithImage.product.price as NSNumber) else { return "$\(productWithImage.product.price)" }
            return fomatted
        }
    }
    
    var installmentText: String {
        get {
            guard let installments = productWithImage.product.installments else { return "" }
            
            guard let formatted = getFormatter().string(from: installments.amount as NSNumber) else { return "$\(installments.amount)" }
            
            let text = "In " + "\(installments.quantity)x " + formatted
            return text
        }
    }
    
    private func getFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "$"
        return formatter
    }
}
