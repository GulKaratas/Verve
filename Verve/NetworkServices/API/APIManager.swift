//
//  APIManager.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    func getData<T: Decodable>(with url: String, completion: @escaping (T?, ApiError?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            }
            catch{
                print(error)
                completion(nil, .decodingError)
            }
        }
        task.resume()
    }
    
    func getDataByIngredients<T: Decodable>(with url: String, completion: @escaping ([T]?, ApiError?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode([T].self, from: data)
                completion(result, nil)
            }
            catch{
                print(error)
                completion(nil, .decodingError)
            }
        }
        task.resume()
    }
}
    
    
