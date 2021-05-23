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
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            formatter.currencySymbol = "$"
            guard let fomatted = formatter.string(from: productWithImage.product.price as NSNumber) else { return "$\(productWithImage.product.price)" }
            return fomatted
        }
    }
}
