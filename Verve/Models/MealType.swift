//
//  MealType.swift
//  TittoAppetito
//
// Created by Gül Karataş on 8.05.2024.
//

import Foundation

//CaseIterable array yapar
enum MealType: String, CaseIterable {
    static var allCases: [MealType] {
        return [
            .appetizer,
            .breakfast,
            .soup,
            .sauce,
            .salad,
            .dessert,
            .snack,
            .beverage
        ]
    }
    
    case appetizer = "appetizer"
    case breakfast = "breakfast"
    case soup = "soup"
    case sauce = "sauce"
    case salad = "salad"
    case dessert = "dessert"
    case snack = "snack"
    case beverage = "drink"
}
