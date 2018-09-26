//
//  ColorViewController.swift
//  base
//
//  Created by Nikola Milic on 9/18/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import UIKit

class ColorViewController: BaseViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    override func applyStyle() {
        super.applyStyle()
        style.apply(textStyle: .title, to: myLabel)
        style.apply(textStyle: .button, to: myButton)
    }
    
}
