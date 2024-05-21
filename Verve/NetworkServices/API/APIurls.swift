//
//  APIurls.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation

final class APIurlsGenerator {
    
   static func urlWithMealTypes(mealType: String) -> String {
       let apiKey = "94ac5621e300495fa81bf9e814fa3f69"
       let numberOfRecipes = 5
       let url = "https://api.spoonacular.com/recipes/random?number=\(numberOfRecipes)&tags=\(mealType)&apiKey=\(apiKey)"
       return url
    }
    
    static func urlWithIngredients(ingredients: String) -> String {
        let apiKey = "94ac5621e300495fa81bf9e814fa3f69"
        let numberOfRecipes = 15
        let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredients)&number=\(numberOfRecipes)&apiKey=\(apiKey)"
        return url
    }
    
    static func urlForIngredientsByCategory() -> String {
        "https://run.mocky.io/v3/7a7b6980-6bb7-4cdb-9745-6b61b63895c4"
    }
}
