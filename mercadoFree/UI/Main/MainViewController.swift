//
//  MainViewController.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 23/05/21.
//

import UIKit

protocol MainViewControllerInterface: AnyObject {
    var presenter: MainViewControllerPresenterInterface? { get }
    
    func displayLoadingIndicator()
    func hideLoadingIndicator(completion: (() -> Void)?)
    func displayProducts()
    func displayErrorAlert(with message: String)
}

class MainViewController: UIViewController, MainViewControllerInterface {
    
    var presenter: MainViewControllerPresenterInterface?
    var spinnerController: SpinnerViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet private weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainViewControllerPresenter(viewInterface: self, productRepository: ProductService())
       
        view.backgroundColor = .yellow
        searchController.searchBar.backgroundColor = .yellow
        searchController.searchBar.placeholder = "Search in MercadoFree"
        searchController.searchBar.delegate = self        
        
        navigationItem.searchController = searchController
    }
}

// MARK: MainViewControllerInterface

extension MainViewController {
    
    func displayProducts() {
        searchController.dismiss(animated: true, completion: nil)
        productsTableView.reloadData()
    }
    
    func displayLoadingIndicator() {
        spinnerController = SpinnerViewController()
        guard let controller = spinnerController else { return }
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    func hideLoadingIndicator(completion: (() -> Void)? = nil) {
        guard let controller = spinnerController else { return }
        controller.dismissView(completion: completion)
    }
    
    func displayErrorAlert(with message: String) {
        hideLoadingIndicator {
            let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default,handler: { action in
                self.searchController.searchBar.becomeFirstResponder()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { presenter?.getProductCount() ?? 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell {
            cell.prodcutForCell = presenter?.getProduct(for: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }

}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Go to product details
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (presenter?.getProductCount() ?? 0) - 1 == indexPath.row {
            presenter?.getNextProducts()
        }
    }
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate  {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        presenter?.getProductsForQuery(query: searchBar.text ?? "")
    }
}
