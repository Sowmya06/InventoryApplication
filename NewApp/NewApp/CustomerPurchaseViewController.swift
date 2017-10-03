//
//  CustomerPurchaseViewController.swift
//  NewApp
//
//  Created by Sowmya on 9/14/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import Firebase

class CustomerPurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalCostsLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    var bookArr = [Item]()
    let user = Auth.auth().currentUser
    var item: Item?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        observeCartData()
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "cartSegue", sender: nil)
    }
    
    func updateTotalCostsLabel() {
        let productPriceFormatter = NumberFormatter()
        productPriceFormatter.numberStyle = .currency
        productPriceFormatter.locale = NSLocale.current
        totalCostsLabel.text = productPriceFormatter.string(from: totalPriceInCart() as NSNumber)
    }
    
    func totalPriceInCart() -> Double {
        var totalPrice: Double = 0
        for book in bookArr {
            totalPrice += book.price
        }
        return totalPrice
    }
    
    func clearCart() {
        setEmptyViewVisible(visible: true)
        updateTotalCostsLabel()
    }
    
    func observeCartData(){
        
        guard let uid = user?.uid  else{
            return
        }
        let uref = Database.database().reference()
        let userCartRef = uref.child("userCart").child(uid)

        userCartRef.observe(.childAdded, with: { (snapshot) in
            let bookKey = snapshot.key
            let dbRef = Database.database().reference().child("Books")
            dbRef.queryOrderedByKey().queryEqual(toValue: bookKey).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
            
                    if let bookData = dictionary[bookKey] as? [String:Any]{
                        let item = Item.init(dictionary: bookData, key: bookKey)
                        self.bookArr.append(item)
                    }
                }
                self.tableView.insertRows(at: [IndexPath(row: self.bookArr.count-1, section: 0)], with: .automatic)
                //self.tableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: self.bookArr)
            })
        }, withCancel: nil)
        
        
    }
    
   
    func setEmptyViewVisible(visible: Bool) {
        emptyView.isHidden = visible
        if visible {
            clearButton.isEnabled = false
            self.view.bringSubview(toFront: emptyView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            let x = view.bounds.size.width/2
            let y = view.bounds.size.height/2
            label.center = CGPoint(x: x, y: y)
            label.textAlignment = .center
            label.text = "No items in your cart."
            self.view.addSubview(label)
        } else {
            clearButton.isEnabled = true
            self.view.sendSubview(toBack: emptyView)
            
        }
    }
    
    func checkEmptyStateOfCart() {
        if bookArr.count == 0 {
            setEmptyViewVisible(visible: true)
        }
        
    }
    
    //MARK: TableViewDelegate and Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerPurchaseTableViewCell
        let item = bookArr[indexPath.row]
        cell.title?.text = item.title
        cell.price?.text = String(describing: item.price)
        if let imageUrl  = item.image {
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.bookImage?.image = UIImage(data: data!)
                }
            }).resume()
            
        }
        updateTotalCostsLabel()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = user?.uid  else{
            return
        }
        if editingStyle == .delete {
            
            self.tableView.beginUpdates()
            
            let bookItem = bookArr[indexPath.row]
            let ref = Database.database().reference().child("userCart").child(uid).child(bookItem.key)
            ref.removeValue()
            bookArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            updateTotalCostsLabel()
            
            self.tableView.endUpdates()
            
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: bookArr)
            
        }
        checkEmptyStateOfCart()
    }
}
