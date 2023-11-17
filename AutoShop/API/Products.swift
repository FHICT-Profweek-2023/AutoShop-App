//
//  Products.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let price: Int
}

class Products {
    
    static func GetProductList(finished: @escaping (_ productList: [Product]) -> Void) {
        
        guard let url = URL(string: "http://192.168.160.53/api/products") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            if let data = data {
                do {
                    let json = try JSONDecoder().decode([Product].self, from: data)
                    
                    DispatchQueue.main.async {
                        finished(json)
                    }
                // Check failures
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
    }
}
