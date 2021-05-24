//
//  ProductTableViewCell.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 23/05/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productInstallmentsLabel: UILabel!
    
    var prodcutForCell: ProductForCell? {
        didSet {
            setUpCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func setUpCell() {
        productTitleLabel.text = prodcutForCell?.productWithImage.product.title
        productPriceLabel.text = prodcutForCell?.formattedPrice
        productInstallmentsLabel.text = prodcutForCell?.installmentText
        if let data = prodcutForCell?.productWithImage.image {
            productImageView.image = UIImage(data: data)
        }
    }
}
