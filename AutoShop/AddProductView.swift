//
//  AddProductView.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import UIKit

class AddProductView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AddProductView: UITableViewDelegate {
    
}

extension AddProductView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
