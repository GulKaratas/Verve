//
//  RecipeByIngredients.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation
//malzemelere göre tarifler
struct RecipeByIngredients: Decodable {
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let usedIngredients: [UsedIngredient]
    let missedIngredients: [MissedIngredient]
}
//eksik malzeme
struct MissedIngredient: Decodable {
    let name: String
    let amount: Double
    let image: String
}
//kullanılan malzeme
struct UsedIngredient: Decodable {
    let name: String
    let amount: Double
    let image: String
}
