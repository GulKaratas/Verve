//
//  UIImageView+Extension.swift
//  Verve
//
// Created by Gül Karataş on 8.05.2024.
//

import UIKit

extension UIImageView {
    //internetten resim alıp kullnma
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
