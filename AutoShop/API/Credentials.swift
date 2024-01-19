//
//  Credentials.swift
//  AutoShop
//
//  Created by Thomas Valkenburg on 08/01/2024.
//

import Foundation

struct CredentialResult: Codable {
    let success: Bool
    let credential: Credential?
}

struct Credential: Codable {
    let id: Int
    let email: String
    let password: String
}

class Credentials {
    static func GetCredential(username: String, password: String, finished: @escaping (_ credential: CredentialResult) -> Void) {
        guard let url = URL(string: "http://192.168.160.50:8080/api/credentials/\(username)&\(password)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(CredentialResult.self, from: data)
                    
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
