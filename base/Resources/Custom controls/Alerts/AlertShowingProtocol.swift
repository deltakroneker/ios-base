//
//  AlertShowingProtocol.swift
//  base
//
//  Created by Nikola Milic on 9/17/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import Foundation
import UIKit

protocol AlertShowing {
    func showBasicAlert(on vc: UIViewController, title: String, message: String)
    func showIncompleteFormAlert(on vc: UIViewController)
    func showInvalidEmailAlert(on vc: UIViewController)
    func showUnableToRetrieveDataAlert(on vc: UIViewController)
}

extension AlertShowing {
    
    func showBasicAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Incomplete form", message: "Please fill out all the fields in the form.")
    }
    
    func showInvalidEmailAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Invalid email", message: "Please use the correct email.")
    }
    
    func showUnableToRetrieveDataAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Unable to retrieve data", message: "There was a network error. Please try again.")
    }
}
