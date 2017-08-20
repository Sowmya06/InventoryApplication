//
//  CartViewController.swift
//  InventoryApp
//
//  Created by Sowmya on 8/12/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    var d = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return d.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCart", for: indexPath) as! CartTableViewCell
        //loadData(cell: cell, indexPath: indexPath as NSIndexPath)
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    func configureCell(cell: CartTableViewCell, indexPath: NSIndexPath) {
        
        
        cell.configureCell(item: d[indexPath.row])
        
    }
}
