//
//  UIViewController + displayAlert.swift
//  ImageApp
//
//  Created by Egor Kruglov on 12.09.2024.
//

import UIKit

extension UIViewController {
    func displayErrorAlert(_ title: String, _ description: String) {
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction.init(title: "Close", style: .default))
        
        present(alertController, animated: true)
    }
}
