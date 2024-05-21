//
//  UIView+Extension.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

//UIView alt sınıfları kullanmak için
extension UIView {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
