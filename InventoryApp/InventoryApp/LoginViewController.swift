//
//  LoginViewController.swift
//  InventoryApp
//
//  Created by Sowmya on 8/10/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let login = loginEmailTextField.text, let password = passwordTextField.text{
            if let user = self.getUserDetails(username: login, password: password) {
                if user.userType == Constants.customer {
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
                    navigationController?.pushViewController(detailVC, animated: true)
                } else if user.userType == Constants.vendor{
                    let vendorVC = self.storyboard?.instantiateViewController(withIdentifier: "vendorVC") as! VendorViewController
                    navigationController?.pushViewController(vendorVC, animated: true)
                } else{
                    let alert1 = UIAlertController(title: "My ALert", message: "Please enter EmailID and Password", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert1.addAction(actionOk)
                    self.present(alert1, animated: true, completion: nil)
                }
            } else {
                print("Invalid User")
            }
        }
    }
    
    func getUserDetails (username:String, password:String) -> Users? {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", username, password)

        do {
            //go get the results
            let users = try context.fetch(fetchRequest)
            if users.count > 0 {
                return users.first
            }
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }

}
