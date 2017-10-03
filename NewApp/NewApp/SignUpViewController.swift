//
//  SignUpViewController.swift
//  NewApp
//
//  Created by Sowmya on 8/26/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var customerButton: UIButton!
    @IBOutlet weak var vendorButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    var userType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customerButton.isSelected = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        guard let email = emailField.text, let password = passwordField.text, let name = nameField.text else{
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            guard let uid = user?.uid  else{
                return
            }
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(uid)
            
       
            if self.customerButton.isSelected {
                self.userType = "customer"
            } else {
                self.userType = "vendor"
            }
            let values = ["name": name, "email": email, "userData": self.userType]
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err!)
                    return
                }

            })
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
       
            
        })
        
    }
    
    @IBAction func vendorButtonTapped(_ sender: UIButton) {
        vendorButton.isSelected = true
        customerButton.isSelected = false
    }
    
    @IBAction func customerBtnTapped(_ sender: UIButton) {
        customerButton.isSelected = true
        vendorButton.isSelected = false
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
