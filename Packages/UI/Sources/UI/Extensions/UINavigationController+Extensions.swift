//
//  File.swift
//
//
//  Created by Quentin Eude on 20/08/2021.
//

import Foundation
import UIKit

public extension UINavigationController {
    func setClear() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    func setDefault() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
    }
}
