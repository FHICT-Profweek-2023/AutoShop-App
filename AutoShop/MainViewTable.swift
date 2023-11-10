//
//  MainViewTable.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import UIKit

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped: ")
        print(indexPath.row)
    }
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
}
