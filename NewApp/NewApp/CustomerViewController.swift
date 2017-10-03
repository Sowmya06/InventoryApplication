//
//  CustomerViewController.swift
//  NewApp
//
//  Created by Sowmya on 9/12/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import Firebase
import MIBadgeButton_Swift

class CustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var wishListButton: MIBadgeButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var badgeButton: MIBadgeButton!
    @IBOutlet weak var tableView: UITableView!
    
    var inSearchMode = false
    var items = [Item]()
    var filteredItems = [Item]()
    var bookArray = [Item]()
    var wishListArray = [Item]()
    var item: Item!
    
    let ref = Database.database().reference(withPath: "Books")
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    updateBadge()
        wishListButton.isSelected = false
        navigationItem.title = "My Name"
        let pdRef = Database.database().reference()
        pdRef.child("users").child((user?.uid)!).child("name").observe(.value, with: { (snapshot) in
            if let userName = snapshot.value as? String {
                self.navigationItem.title = userName
            }
        })
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        wishListButton.setImage(#imageLiteral(resourceName: "heartitem"), for: .normal)
        wishListButton.addTarget(self, action: #selector(addWishItem(sender:)), for: UIControlEvents.touchUpInside)
        badgeButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        badgeButton.addTarget(self, action: #selector(addItem(sender:)), for: UIControlEvents.touchUpInside)
        let barItem: UIBarButtonItem  = UIBarButtonItem(customView: wishListButton)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: badgeButton)
        self.navigationItem.setRightBarButtonItems([barButton, barItem], animated: true)
        
        observeDataFromFirebase()
        
    }
    
    func observeDataFromFirebase(){
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Item] = []
            
            for item in snapshot.children {
                let bookItem = Item(snapshot: item as! DataSnapshot)
                newItems.append(bookItem)
            }
            self.items = newItems
            self.tableView.reloadData()
        })
        
    }
    
    func updateBadge(){
        guard let uid = user?.uid  else{
            return
        }
        let uref = Database.database().reference().child("userCart").child(uid)
        uref.observe(.value, with: { (snapshot: DataSnapshot!) in
            print("Got snapshot");
            let childCount = snapshot.childrenCount
            self.badgeButton.badgeString = String(childCount)
        })
    }
    
    func addWishItem(sender: UIBarButtonItem){
        print(wishListArray.count)
    }
    
    func addItem(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "cartDetail", sender: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.arrayUpdate(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
//    func arrayUpdate(notification: Notification) {
//        bookArray = notification.object as! Array
//        
//        badgeButton.badgeString = String(bookArray.count)
//    }
    
     //MARK: TableViewDelegate and Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerTableViewCell
        if inSearchMode {
            item = filteredItems[indexPath.row]
            cell.configureCell(item)
        } else {
            item = items[indexPath.row]
            cell.configureCell(item)
        }
        //badgeButton.badgeString = String(self.bookArray.count)
        cell.onButtonTapped = {
            
            if self.items.count > 0 {
                let cellData = self.items[indexPath.row]
                self.bookArray.append(cellData)
                guard let uid = self.user?.uid  else{
                    return
                }
                let uref = Database.database().reference()
                let userCartRef = uref.child("userCart").child(uid)
                for books in self.bookArray{
                    let key = books.key
                    userCartRef.updateChildValues([key : 1])
                }
                self.showToast(message: "Item added to your cart")
                
            }
            
        }
        cell.onHeartTapped = {
            if self.items.count > 0 {
                let cellData = self.items[indexPath.row]
                self.wishListArray.append(cellData)
                self.wishListButton.isSelected = true
                self.showToast(message: "Item added to your wish list")
            }
            self.wishListButton.badgeString = String(self.wishListArray.count)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.capitalized
            filteredItems = items.filter({$0.title.range(of: lower) != nil})
            tableView.reloadData()
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-100, y: self.view.frame.size.height-100, width: 220, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
  

}
