//
//  IngredientsAPI.swift
//  Glass Bottle
//
//  Created by Saransh Duggal on 2022-04-25.
//

import UIKit

protocol IngredientAPIDelegate {
    func ingredientAPIData(parsedData data: [String])
}

struct IngredientsAPIManager {
    var delegate: IngredientAPIDelegate?
    
//MARK: Fetching Product Ingredient List from Ingredients API
    func getIngredientList(api url: String) {
    
        guard let safeURL = URL(string: url)
        else {
            fatalError("Ingredients URL is nil.")
        }
        
        print(safeURL)
        
        print("Something went wrong.")
        
        let task = URLSession.shared.dataTask(with: safeURL, completionHandler:{ (data, response, error) in
            
            guard let safeData = data, error == nil
            else {
                fatalError("Unable to get data from Ingredients API.")
            }
            
            guard let finalData = self.parseIngredientJSON(JSON: safeData)
            else {
                fatalError("Unable to parse Ingredient API JSON Data.")
            }
            self.delegate?.ingredientAPIData(parsedData: finalData)
            print("Used Protocol")
        })
        
        task.resume()
    }
    
//MARK: - Parsing Ingredients API JSON Data
        func parseIngredientJSON(JSON data: Data) -> [String]? {
            
            //Decoding Ingredient API Data
            var result: [IngredientsAPIResults]?
            do {
                result = try JSONDecoder().decode([IngredientsAPIResults].self, from: data)
            }
            catch {
                print("Failed to convert \(error)")
            }
            
            guard let ingredientsAPIParsedData = result else {
                fatalError()
            }
            
            //Displaying the cosmetic item data by acessing the array
            let productIngredients = ingredientsAPIParsedData.flatMap {
                $0.ingredient_list
            }
            
            return productIngredients
        }

}
