//
//  IngredientsByCategory.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation
//malzeme JSON
struct IngredientsByCategory: Decodable {
    let results: [IngredientCategory]
}
// malzeme kategorileri başlığı vs.
struct IngredientCategory: Decodable {
    let title: String
    let image: String
    let ingredients: [String]
}
