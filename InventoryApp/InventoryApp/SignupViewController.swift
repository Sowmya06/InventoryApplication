//
//  ViewController.swift
//  InventoryApp
//
//  Created by Sowmya on 8/9/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var buttonCustomer: UIButton!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonVendor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCustomer.isSelected = true
    }
    
    func isValidEmail(emailId: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnVendorTapped(_ sender: Any) {
        buttonCustomer.isSelected = false
        buttonVendor.isSelected = true
    }
    
    @IBAction func btnCustomerTapped(_ sender: Any) {
        buttonCustomer.isSelected = true
        buttonVendor.isSelected = false
    }
    @IBAction func signUp(_ sender: UIButton) {
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDeletgate.persistentContainer.viewContext
        let user =  Users(context: context)
        user.firstName = firstName.text
        user.lastName = lastName.text
        
        
        if let textData = emailId.text {
            let validEmail = isValidEmail(emailId: textData)
            if validEmail{
                print("valid")
                user.email = textData
            }
            else{
                print("not valid")
                let alert1 = UIAlertController(title: "My ALert", message: "Please enter valid Email", preferredStyle: UIAlertControllerStyle.alert)
                
                let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert1.addAction(actionOk)
                self.present(alert1, animated: true, completion: nil)
            }
            
        }
       
        
        if let mob = mobileNumber.text{
            if let mob1 = Int32(mob){
                user.mobile =  mob1
            }
        }
        
        if buttonCustomer.isSelected {
            user.userType = Constants.customer
        } else {
            user.userType = Constants.vendor
        }
        
        
        if password.text == confirmPassword.text{
           user.password = password.text
        } else {
            let alert1 = UIAlertController(title: "Password Alert", message: "Passwords not matching", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert1.addAction(actionOk)
            self.present(alert1, animated: true, completion: nil)

        }
        appDeletgate.saveContext()
       _ = navigationController?.popViewController(animated: true)

    }
    
}

