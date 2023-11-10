//
//  ViewController.swift
//  AutomatedShoppingCart
//
//  Created by Thomas Valkenburg on 06/11/2023.
//

import UIKit

class MainView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        let timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) {_ in
                    Products.GetProductList { products in
                        self.products = products
                    }
                }
        timer.fire()
    }
    
    var products: [Product]?
    
    @IBOutlet weak var StartStopButton: UIButton!
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBAction func StartStopButtonPressed(_ sender: UIButton) {
        let playImage = UIImage(systemName: "play.circle")
        
        if  StartStopButton.image(for: .normal) == nil || StartStopButton.image(for: .normal) == playImage {
            StartStopButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            StartStopButton.configuration?.baseForegroundColor = .systemRed
        }
        else {
            StartStopButton.setImage(playImage, for: .normal)
            StartStopButton.configuration?.baseForegroundColor = .systemGreen
        }
        
    }
}
