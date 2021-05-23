//
//  UIViewController+Extensions.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 23/05/21.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white.withAlphaComponent(0.8)
        spinner.color = .systemBlue
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func dismissView(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}
