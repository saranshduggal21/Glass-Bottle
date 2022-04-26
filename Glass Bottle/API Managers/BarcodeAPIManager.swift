//
//  BarcodeAPI.swift
//  Glass Bottle

import UIKit

//MARK: - Delegate Method to Pass Data to ViewController Class
protocol BarcodeAPIDelegate {
    func barcodeAPIData(parsedData data: BarcodeAPIModel) -> String
}

struct BarcodeAPIManager {
    var delegate: BarcodeAPIDelegate?

//MARK: Calling Barcode API
    func getProductData(using productURL: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: productURL)!, completionHandler:{ (data, response, error) in
            guard let safeData = data, error == nil
            else {
                fatalError("Unable to get data from Barcode API.")
            }
            
            guard let finalData = self.parseJSON(json: safeData)
            else {
                fatalError("Unable to parse JSON Data from Barcode API.")
            }
            delegate?.barcodeAPIData(parsedData: finalData)
        })
        
        task.resume()
        
    }
    
//MARK: - Parsing Barcode API JSON Data
    func parseJSON(json data: Data) -> BarcodeAPIModel? {
        
        var productNameIngredientsAPI = " " //This is the variable that will be passed to the Ingredients API
        
        //Decoding Barcode API Data
        var result: BarcodeAPIResult?
        
        do {
            result = try JSONDecoder().decode(BarcodeAPIResult.self, from: data)
        }
        catch {
            fatalError("Failed to decode Barcode API data.")
        }
        
        guard let barcodeAPIParsedData = result
        else {
            fatalError("Barcode API results are nil.")
        }
        
        //Displaying the cosmetic item data by acessing the array
        let productName = barcodeAPIParsedData.items[0].title
        
        let productNameArray = productName.components(separatedBy: " ")
        
        for i in 0...3 {
            productNameIngredientsAPI.append(productNameArray[i])
            if i < 3 {
                productNameIngredientsAPI.append("+")
            }
        }
        
        print("Bye\(productNameIngredientsAPI)")
        
        let finalProductData = BarcodeAPIModel(productName: productNameIngredientsAPI)
        
        return finalProductData
    }
}
