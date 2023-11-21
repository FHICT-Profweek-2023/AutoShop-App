//
//  Controls.swift
//  AutoShop
//
//  Created by Thomas Valkenburg on 15/11/2023.
//

import Foundation

struct Control: Codable {
    let id: Int
    var halt: Bool
    var next_product: Int?
    let current_position: Int
}

class Controls {
    
    static func GetControl(finished: @escaping (_ control: Control) -> Void) {
        
        let id = 0
        
        guard let url = URL(string: "http://192.168.160.53/api/Controls/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Control.self, from: data)
                    
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
    
    static func PutControl(control: Control) {
        do{
            var request = URLRequest(url: URL(string: "http://192.168.160.53/api/controls/0")!)
            request.httpMethod = "PUT"
            
            request.httpBody = try JSONEncoder().encode(control)
            
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                if let response = response {
                    print ("status code = \((response as! HTTPURLResponse).statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                }
            }).resume()
        // Check for error
        } catch {
            print ("Controls PUT failed")
        }
    }
}
