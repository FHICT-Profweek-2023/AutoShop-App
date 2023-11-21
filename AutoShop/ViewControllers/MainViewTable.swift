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

/// <summary>
///     Add protocal function
/// </summary>
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
    
    /// <summary>
    ///     Add preperation for segue to set new VC's delegate to self
    /// </summary>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destinationVC = segue.destination as! AddProductView
        //destinationVC.delegate = self
        
        if let destVC = segue.destination.children.first as? AddProductView {
            destVC.delegate = self
        }
    }
}

extension MainView: UITableViewDataSource {
    /// <summary>
    ///     Add Header for table view
    /// </summary>
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Winkelmandje"
    }
    
    /// <summary>
    ///     Add Footer for table view
    /// </summary>
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var totalPrice = 0
        
        // Sum up prices of all products
        groupedCartList?.values.forEach({ cart in
            totalPrice += cart.count * (cart.first?.product.price ?? 0)
        })
        
        // Return total price
        return "Totaal: €\(totalPrice)"
    }
    
    /// <summary>
    ///     Select amount of rows needed
    /// </summary>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartList != nil {
            groupedCartList = Dictionary(grouping: CartList!, by: \.product.id)
        }
        
        controls?.next_product = groupedCartList?.values.sorted(by: { cart1, cart2 in
            cart1.first?.product.id ?? 0 < cart2.first?.product.id ?? 0
        }).first(where: { Cart in
            Cart.first!.product.id >= controls!.current_position
        })?.first?.product.id ?? nil
        
        // Return groupedCartList.count if is bigger than 0, else return 1 (Always return 1 or higher)
        return groupedCartList?.count ?? 0 >= 1 ? groupedCartList!.count : 1
    }
    
    /// <summary>
    ///     Set cells for index
    /// </summary>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell class
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableCell
        
        // Check if any products in cart list
        if (groupedCartList != nil && !groupedCartList!.isEmpty) {
            // Sort products by location (id)
            let arr = Array(groupedCartList!.values).sorted(by: { $0.first!.product.id < $1.first!.product.id } )
            
            // Get product for current index
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
            
            // Make sure buttons aren't hidden
            cell.MinusButton.isHidden = false
            cell.PlusButton.isHidden = false
            cell.AmountLabel.isHidden = false
            
            return cell
        }
        
        // No products in cart state
        // Set text and hide buttons
        cell.TitleLabel.text = "Geen producten geselecteerd."
        cell.MinusButton.isHidden = true
        cell.PlusButton.isHidden = true
        cell.AmountLabel.isHidden = true
        
        return cell
    }
    
    @objc func minusButtonTapped(sender: UIButton) {
        guard let cartIndex = CartList?.firstIndex(where: { $0.product.id == sender.tag }) else { return }
        // Remove product from list
        CartList?.remove(at: cartIndex)
    
        // Reload
        cartTableView.reloadSections([0], with: .automatic)
    }
    
    @objc func plusButtonTapped(sender: UIButton) {
        guard let cart = CartList?.first(where: { $0.product.id == sender.tag }) else { return }
        // Add product to list
        CartList?.append(cart)
        
        // Reload
        cartTableView.reloadSections([0], with: .automatic)
    }
}
