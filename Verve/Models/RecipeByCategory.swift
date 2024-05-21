//
//  RecipeByCategory.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation

//tarif kategori JSON
struct RecipeByCategory: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    let title: String
    let readyInMinutes: Int
    let sourceUrl: String
    let image: String
}
