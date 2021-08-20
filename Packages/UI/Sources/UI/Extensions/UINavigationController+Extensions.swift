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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setDefault() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
}
