//
//  ItemDetailViewController.swift
//  NewApp
//
//  Created by Sowmya on 9/4/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class VendorDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var itemToEdit: Item?
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        print("viewDidLoad beofe" + Date().description)
        super.viewDidLoad()
        if itemToEdit != nil {
            loadItemData()
        }
        print("viewDidLoad after" + Date().description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleTextField.text = item.title
            priceTextField.text = "\(String(describing: item.price))"
            if let imageUrl  = item.image ,
                let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data!)
                    }
                }).resume()
                
            }
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var bookData: Item!
        
        if let text1 = titleTextField.text, let text2 = priceTextField.text, let bookPicture = imageView.image{

            let priceData = Double(text2)
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Book_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(bookPicture){
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let bookImageUrl = metaData?.downloadURL()?.absoluteString{
                        
                        if self.itemToEdit == nil {
                            
                            bookData = Item(title: text1, price: priceData!, image: bookImageUrl, addedBy: (self.user?.uid)!)
                            let refData = self.ref.child("Books").childByAutoId()
                            refData.setValue(bookData.toAnyObject())
                            
                            
                        } else {
                            bookData = self.itemToEdit
                            let updatedBookData  = Item(title: text1, price: priceData!, image: bookImageUrl, addedBy: (self.user?.uid)!)
                            let key = bookData.ref!.key
                            let updateRef = self.ref.child("/Books/\(key)")
                            updateRef.updateChildValues(updatedBookData.toAnyObject())
                        }
                    }
                    
                })
                _ = navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageInfo = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = imageInfo
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
