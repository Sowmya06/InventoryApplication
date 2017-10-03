//
//  ViewController.swift
//  NewApp
//
//  Created by Sowmya on 8/25/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var button: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else{
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            let user = Auth.auth().currentUser
            let pdRef = Database.database().reference()
            
            pdRef.child("users").child((user?.uid)!).child("userData").observe(.value, with: { (snapshot) in
                if let userType = snapshot.value as? String {
                    if userType == "customer" {
                        print("Customer")
                        self.performSegue(withIdentifier: "customerSegue", sender: nil)
                    } else if userType == "vendor"{
                        print("Vendor")
                        self.performSegue(withIdentifier: "itemSegue", sender: nil)
                    }
                }
            })
        })
        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Inventory App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func registerTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }
}

