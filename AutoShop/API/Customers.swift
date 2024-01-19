//
//  Customers.swift
//  AutoShop
//
//  Created by Thomas Valkenburg on 15/01/2024.
//

import Foundation

struct Customer: Codable {
    let id: Int
    let first_Name: String
    let last_Name: String
    let email: String
    let gender: String
    let birthday: String
    let country: String
    let adress: String
    let postalcode: String
}

class Customers {
    static func GetAccount(id: Int, finished: @escaping (_ customer: Customer) -> Void) {
        guard let url = URL(string: "http://192.168.160.50:8080/api/customers/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Customer.self, from: data)
                    
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
