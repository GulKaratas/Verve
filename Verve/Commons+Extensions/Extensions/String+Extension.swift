//
//  String+Extension.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

extension String {
  func firstLetterUppercased() -> String {
    guard let first = first, first.isLowercase else { return self }
    return String(first).uppercased() + dropFirst()
  }
}
// İlk harfi büyüğe çevir
