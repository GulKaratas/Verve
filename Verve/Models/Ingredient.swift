//
//  Ingredient.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

//malzeme kullanıcı seçme
class Ingredient {
    let name: String
    var isSelected: Bool
    
    init(
        name: String,
        isSelected: Bool = false
    ) {
        self.name = name
        self.isSelected = isSelected
    }
}
