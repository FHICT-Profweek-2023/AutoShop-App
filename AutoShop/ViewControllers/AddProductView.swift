//
//  AddProductView.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import UIKit

protocol AddProductToCart : AnyObject {
    func addProduct(product: Cart)
}

class AddProductView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        productTableView.delegate = self
        productTableView.dataSource = self
        
        Products.GetProductList { products in
            self.products = products
            self.filteredProducts = self.products?.sorted(by: { Product1, Product2 in
                Product1.name ?? "" < Product2.name ?? ""
            })
            
            self.productTableView.reloadSections([0], with: .automatic)
        }
    }
    
    var filteredProducts: [Product]?
    var products: [Product]?
    
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate : AddProductToCart?
    
    @IBAction func CloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AddProductView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(filteredProducts![indexPath.row].name!)
        delegate!.addProduct(product: Cart(product: filteredProducts![indexPath.row]))
    }
}

extension AddProductView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "€\(filteredProducts?[indexPath.row].price ?? 0) - \(filteredProducts?[indexPath.row].name ?? "")"
        cell.detailTextLabel?.text = filteredProducts?[indexPath.row].description ?? ""
        
        return cell
    }
}

extension AddProductView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredProducts = []
        if (searchText == "") {
            filteredProducts = products?.sorted(by: { Product1, Product2 in
                Product1.name ?? "" < Product2.name ?? ""
            })
        }
        
        if let products {
            for product in products {
                if (product.name != nil && (product.name!.lowercased().contains(searchText.lowercased()) || product.description!.lowercased().contains(searchText.lowercased()))) {
                    filteredProducts?.append(product)
                }
            }
        }
        
        productTableView.reloadSections([0], with: .automatic)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
