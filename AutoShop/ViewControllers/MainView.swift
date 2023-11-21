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
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            Controls.GetControl(finished: { control in
                self._controls = control
                
                guard let nextProduct = control.next_product else {
                    self.productLabel.text = "Geen producten geselecteerd"
                    self.progressView.setProgress(0.0, animated: true)
                    return
                }
                
                let progress = (Float(control.current_position - self.startPosition) / Float(nextProduct - self.startPosition))
                self.progressView.setProgress(progress, animated: true)
                
                if (control.current_position == control.next_product && control.halt == false) {
                    self.startPosition = control.current_position
                    self.cartTableView.reloadData()
                }
                
                Products.GetProduct(id: nextProduct) { product in
                    self.productLabel.text = product.name
                }
            })
        }
        timer.fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if CartList == nil || CartList!.isEmpty {
            performSegue(withIdentifier: "AddProductViewSegue", sender: self)
        }
    }
    
    var groupedCartList: Dictionary<Int, [Cart]>?
    
    var startPosition: Int = 0
    var _controls: Control?
    var controls: Control? { get {
        return _controls
    } set {
        guard let newValue else { return }
        
        _controls = newValue
        Controls.PutControl(control: newValue)
    }}
    
    var CartList: [Cart]?
    
    @IBOutlet weak var StartStopButton: UIButton!
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBAction func StartStopButtonPressed(_ sender: UIButton) {
        let playImage = UIImage(systemName: "play.circle")
        
        if  StartStopButton.image(for: .normal) == nil || StartStopButton.image(for: .normal) == playImage {
            controls?.halt = false
        } else {
            controls?.halt = true
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return print("Self is nil!") }
            self.ChangeStartStopButton()
        }
    }
    
    func ChangeStartStopButton() {
        if (controls != nil && controls!.halt) {
            StartStopButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            StartStopButton.configuration?.baseForegroundColor = .systemGreen
        }
        else {
            StartStopButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            StartStopButton.configuration?.baseForegroundColor = .systemRed
        }
    }
}
