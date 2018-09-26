//
//  BaseViewController.swift
//  base
//
//  Created by Nikola Milic on 9/18/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var style: Style = Style.base
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func applyStyle() {
        view.backgroundColor = style.backgroundColor
        if let navBar = navigationController?.navigationBar {
            style.apply(to: navBar)
        }
    }

}
