//
//  Constants.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

enum Color: String {
    case background = "#faf7f5"
    case main = "#000000"
    case secondary = "#8c8d8c"
    case name = "#4A6992"
    case cell = "#ffffff"
    case border = "#EEE4DE"
}

enum CornerRadius: CGFloat {
    case textView = 5
    case cell_smallSize = 3
    case image_cell = 6
    case cell_bigSize = 10
    case button = 15
}

enum RecipePlaceholder: String {
    case Title, Ingredients, Method
}

enum AssetName: String {
    case recipe_default = "recipe_default"
}

enum LabelText: String {
    case usedIngredients = "Used Ingredients:"
    case missedIngredients = "Missed Ingredients:"
    case fridgePageMain = "What's In Your Fridge?"
    case myRecipesPageMain = "My Recipes"
}

enum AppName: String {
    case appName = "Verve"
}

enum TableViewRowHeight: CGFloat {
    case forHomeViewController = 200
}
