//
//  MainViewTable.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 08/11/2023.
//

import UIKit

class Cart{
    var product: Product
    
    init(product: Product) {
        self.product = product
    }
}

extension MainView: AddProductToCart{
    func addProduct(product : Cart) {
        if (CartList == nil) {
            CartList = [product]
        }
        else {
            CartList?.append(product)
        }
        
        cartTableView.reloadSections([0], with: .automatic)
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destinationVC = segue.destination as! AddProductView
        //destinationVC.delegate = self
        
        if let destVC = segue.destination.children.first as? AddProductView {
            destVC.delegate = self
        }
    }
}

extension MainView: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartList != nil {
            groupedCartList = Dictionary(grouping: CartList!, by: \.product.id)
        }
        
        controls?.next_product = groupedCartList?.values.sorted(by: { cart1, cart2 in
            cart1.first?.product.id ?? 0 < cart2.first?.product.id ?? 0
        }).first(where: { Cart in
            Cart.first!.product.id >= controls!.current_position
        })?.first?.product.id ?? nil
        
        return groupedCartList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell class
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableCell
        
        let arr = Array(groupedCartList!.values).sorted(by: { $0.first!.product.id < $1.first!.product.id } )
        
        let product: Product = arr[indexPath.row].first!.product
        
        // Set text for cell
        cell.TitleLabel.text = "€\(product.price) - \(product.name)"
        cell.AmountLabel.text = "\(arr[indexPath.row].count)x - €\(arr[indexPath.row].count * product.price)"
        
        // Add product id to button tag
        cell.MinusButton.tag = product.id
        cell.PlusButton.tag = product.id
        
        // Add targets for + and - button
        cell.MinusButton.addTarget(nil, action: #selector(minusButtonTapped), for: .touchUpInside)
        cell.PlusButton.addTarget(nil, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func minusButtonTapped(sender: UIButton) {
        guard let cartIndex = CartList?.firstIndex(where: { $0.product.id == sender.tag }) else { return }
        CartList?.remove(at: cartIndex)
        
        cartTableView.reloadSections([0], with: .automatic)
    }
    
    @objc func plusButtonTapped(sender: UIButton) {
        guard let cart = CartList?.first(where: { $0.product.id == sender.tag }) else { return }
        CartList?.append(cart)
        
        cartTableView.reloadSections([0], with: .automatic)
    }
}
