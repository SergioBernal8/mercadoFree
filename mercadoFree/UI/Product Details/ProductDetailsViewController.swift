//
//  ProductDetailsViewController.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 24/05/21.
//

import UIKit

protocol ProductDetailsViewControllerInterface: AnyObject {
    var presenter: ProductDetailsViewControllerPresenterInterface? { get }
    
    func reloadData()
}

class ProductDetailsViewController: UIViewController, ProductDetailsViewControllerInterface {
        
    var presenter: ProductDetailsViewControllerPresenterInterface?
    var product: ProductForCell?
    
    @IBOutlet private weak var productDetailsTableView: UITableView!
    @IBOutlet private weak var productImageView: UIImageView!
    
    private let cellRowHeight: CGFloat = 65.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .yellow
        
        presenter = ProductDetailsViewControllerPresenter(viewInterface: self)
        productDetailsTableView.estimatedRowHeight = cellRowHeight
        productDetailsTableView.rowHeight = cellRowHeight
        
        if let product = product {
            productImageView.image = UIImage(data: product.productWithImage.image)
            productDetailsTableView.register(UINib(nibName: "ProductDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailsTableViewCell")
            presenter?.mapProductValues(for: product)            
        }
    }
}

// MARK: ProductDetailsViewController

extension ProductDetailsViewController {
    
    func reloadData() {
        productDetailsTableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension ProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { presenter?.getProductDetailsCount() ?? 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTableViewCell") as? ProductDetailsTableViewCell {
            cell.textDescriptionLabel?.text = presenter?.getProductDetail(for: indexPath.row) ?? ""
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}