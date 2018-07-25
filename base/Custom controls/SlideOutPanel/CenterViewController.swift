//
//  CenterViewController.swift
//  base
//
//  Created by Nikola Milic on 7/23/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate {
    func toggleLeftPanel()
}

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
}

