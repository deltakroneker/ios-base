//
//  UIStoryboardExtensions.swift
//  base
//
//  Created by Nikola Milic on 9/26/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func slideOutStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "SlideOutPanel", bundle: Bundle.main)
    }
    
    static func sideViewController() -> UIViewController? {
        return slideOutStoryboard().instantiateViewController(withIdentifier: "SideViewController")
    }
    
    static func centerViewController() -> CenterViewController? {
        return slideOutStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }

}
