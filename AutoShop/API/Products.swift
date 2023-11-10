//
//  Products.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name: String
    let description: String
    let price: Int
}

class Products {
    
    static func GetProductList(finished: @escaping (_ productList: [Product]) -> Void) {
        
        guard let url = URL(string: "https://192.168.160.53/api/products") else { return }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            
            if let data = data {
                do {
                    
                    let json = try JSONDecoder().decode([Product].self, from: data)
                    
                    DispatchQueue.main.async {
                        finished(json)
                    }
                } catch { print(error.localizedDescription) }
            }
        }.resume()
    }
}
