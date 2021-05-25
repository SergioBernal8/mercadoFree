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
        
        productImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        productImageView.addGestureRecognizer(gesture)
        
        if let productData = product {
            productDetailsTableView.register(UINib(nibName: "ProductDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailsTableViewCell")
            presenter?.mapProductValues(for: productData)
        }
        if let image = product?.productWithImage.image {
            productImageView.image = UIImage(data: image)
        }
    }
    
    @IBAction private func didTapImage() {
        if let url = URL(string: product?.productWithImage.product.permalink ?? "") {
            UIApplication.shared.open(url)
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
