//
//  Style+Base.swift
//  base
//
//  Created by Nikola Milic on 9/18/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import Foundation
import UIKit

extension Style {
    static var base: Style {
        return Style(
            backgroundColor: .red,
            preferredStatusBarStyle: .lightContent,
            attributesForStyle: { $0.baseAttributes }
        )
    }
}

private extension Style.TextStyle {
    var baseAttributes: Style.TextAttributes {
        switch self {
        case .navigationBar:
            return Style.TextAttributes(font: .baseTitle, color: .baseRed, backgroundColor: .black)
        case .title:
            return Style.TextAttributes(font: .baseTitle, color: .baseGreen)
        case .subtitle:
            return Style.TextAttributes(font: .baseSubtitle, color: .baseBlue)
        case .body:
            return Style.TextAttributes(font: .baseBody, color: .black, backgroundColor: .white)
        case .button:
            return Style.TextAttributes(font: .baseSubtitle, color: .white, backgroundColor: .baseRed)
        }
    }
}

extension UIColor {
    static var baseRed: UIColor {
        return UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    }
    static var baseGreen: UIColor {
        return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    }
    static var baseBlue: UIColor {
        return UIColor(red: 0, green: 0.2, blue: 0.9, alpha: 1)
    }
}

extension UIFont {
    static var baseTitle: UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    static var baseSubtitle: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    static var baseBody: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}
