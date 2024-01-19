//
//  ProfileViewController.swift
//  AutoShop
//
//  Created by Thomas Valkenburg on 07/12/2023.
//

import UIKit

protocol SetCustomer : AnyObject {
    func SetCustomer(customer: Customer)
}

class ProfileViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginButton.setTitle("Inloggen", for: .normal)
        LoginButton.setTitle("Laden...", for: .disabled)
        
        if customer != nil {
            FillProfileDetails(customer: customer!)
            HideLogin()
        }
    }
    
    var customer: Customer?
    
    weak var delegate: MainView?
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var PersonImage: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var GenderLabel: UILabel!
    @IBOutlet weak var GenderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var CountryLabel: UILabel!
    @IBOutlet weak var CountrySelectionButton: UIButton!
    
    @IBOutlet weak var BirthdayLabel: UILabel!
    @IBOutlet weak var BirthdayDatePicker: UIDatePicker!
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        if (UsernameTextField.text != "" && PasswordTextField.text != "") {
            self.LoginButton.isEnabled = false
            
            Credentials.GetCredential(username: self.UsernameTextField.text ?? "", password: self.PasswordTextField.text ?? "", finished: { credential in
                if (credential.success) {
                    Customers.GetAccount(id: credential.credential!.id) { customer in
                        self.FillProfileDetails(customer: customer)
                        self.delegate?.SetCustomer(customer: customer)
                    }
                    self.HideLogin()
                    return
                }
                else {
                    let alert = UIAlertController(title: "Ongeldig", message: "De ingevulde gebruikersnaam of wachtwoord is niet geldig", preferredStyle: .alert)
                    alert.addAction(.init(title: "Oke", style: .cancel))
                    
                    self.present(alert, animated: true)
                    
                    self.LoginButton.isEnabled = true
                }
            })
        }
        else {
            let alert = UIAlertController(title: "Ongeldig", message: "De ingevulde gebruikersnaam of wachtwoord is niet geldig", preferredStyle: .alert)
            alert.addAction(.init(title: "Oke", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func CloseButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func HideLogin() {
        self.UsernameTextField.isHidden = true
        self.PasswordTextField.isHidden = true
        self.LoginButton.isHidden = true
        
        self.PersonImage.isHidden = false
        
        self.NameLabel.isHidden = false
        
        self.EmailLabel.isHidden = false
        self.EmailTextField.isHidden = false
        
        self.GenderLabel.isHidden = false
        self.GenderSegmentedControl.isHidden = false
        
        self.CountryLabel.isHidden = false
        self.CountrySelectionButton.isHidden = false
        
        self.BirthdayLabel.isHidden = false
        self.BirthdayDatePicker.isHidden = false
    }
    
    func FillProfileDetails(customer: Customer) {
        self.NameLabel.text = "\(customer.first_Name) \(customer.last_Name)"
        self.EmailTextField.text = customer.email
        self.GenderSegmentedControl.selectedSegmentIndex = customer.gender.lowercased() == "man" ? 0 : 1
        self.BirthdayDatePicker.date = DateFormatter().date(from: customer.birthday) ?? Date.now
    }
}
