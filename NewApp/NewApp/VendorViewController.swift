//
//  ItemViewController.swift
//  NewApp
//
//  Created by Sowmya on 8/26/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import Firebase

class VendorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Item]()
   let imageCache = NSCache<AnyObject, AnyObject>()
    let ref = Database.database().reference(withPath: "Books")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(sender:)))
        
        let user = Auth.auth().currentUser
               
        ref.queryOrdered(byChild: "addedBy").queryEqual(toValue: user?.uid).observe(.value, with: { snapshot in
            
            var newItems: [Item] = []

            for item in snapshot.children {
                let bookItem = Item(snapshot: item as! DataSnapshot)
                newItems.append(bookItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    func addItem(sender: UIBarButtonItem){
        //print("addItem" + Date().description)
        performSegue(withIdentifier: "itemEdit", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        
        let item = items[indexPath.row]
        cell.title?.text = item.title
        cell.price?.text = String(describing: item.price)
        
        if let imageUrl  = item.image {
//            if let cacheImage = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage{
//                print("image cache")
//                cell.bookImage.image = cacheImage
//            }
//            print("image not cache")
            if imageCache.object(forKey: imageUrl as AnyObject) != nil {
            print("cache image used")
                cell.bookImage.image = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage
         }
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let data = data, let downloadImage = UIImage(data: data) {
                       // print(downloadImage)
                        self.imageCache.setObject(downloadImage as AnyObject, forKey: imageUrl as AnyObject)
                        cell.bookImage?.image = downloadImage
                    }
                }
            }).resume()
            //}
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            let bookItem = items[indexPath.row]
            //to remove items from firebase
            bookItem.ref?.removeValue()
            //to remove items from an array and tableview
            //items.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            self.tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items.count > 0 {
            let item = items[indexPath.row]
            performSegue(withIdentifier: "itemEdit", sender: item)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemEdit" {
            if let destination = segue.destination as? VendorDetailViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
        
    }
    
}
