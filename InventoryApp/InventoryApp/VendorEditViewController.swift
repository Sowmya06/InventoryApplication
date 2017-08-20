//
//  VendorEditViewController.swift
//  InventoryApp
//
//  Created by Sowmya on 8/14/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class VendorEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var savePressed: UIButton!
    
    var itemToEdit: Book?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var books: Book!
        
        if itemToEdit == nil {
            books = Book(context: context)
        } else {
            
            books = itemToEdit
            
        }
        
        if let title = titleField.text {
            
            books.title = title
            
        }
        
        if let price = priceField.text, let cost = Double(price) {
            
            books.price = cost
            
        }
        books.image = imageView.image
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            imageView.image = item.image as? UIImage
            
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageInfo = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = imageInfo
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
