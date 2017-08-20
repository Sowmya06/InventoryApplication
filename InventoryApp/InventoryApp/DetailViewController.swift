//
//  DetailViewController.swift
//  InventoryApp
//
//  Created by Sowmya on 8/10/17.
//  Copyright © 2017 Sowmya. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var fetchController: NSFetchedResultsController<Book>!
    var bookArray = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Customer"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart"), style: .plain, target: self, action: #selector(addItem(sender:)))
        
        attemptFetch()
        // generateTestData()
        
    }
    
    func addItem(sender: UIBarButtonItem){
        if bookArray.count == 0 {
            let alert1 = UIAlertController(title: "My ALert", message: "No items in Cart", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert1.addAction(actionOk)
            self.present(alert1, animated: true, completion: nil)
        }else {
        let cartDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "cartDetail") as! CartViewController
        navigationController?.pushViewController(cartDetailsVC, animated: true)
        cartDetailsVC.d = bookArray
        }
       // print(bookArray)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        cell.onButtonTapped = {
            if let obj = self.fetchController.fetchedObjects, obj.count > 0 {
                let cellData = obj[indexPath.row]
                self.bookArray.append(cellData)
                //print(self.bookArray)
            }
            
        }
        return cell
    }
    
    func configureCell(cell: BookCell, indexPath: NSIndexPath) {
        
        let book = fetchController.object(at: indexPath as IndexPath)
        cell.configureCell(item: book)
        
    }
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [titleSort, priceSort]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchController.delegate = self
        do {
            
            try fetchController.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
        
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! BookCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    func generateTestData() {
        
        let item = Book(context: context)
        item.title = "Secret"
        item.price = 20
        
        
        let item2 = Book(context: context)
        item2.title = "Java"
        item2.price = 30
        
        
        let item3 = Book(context: context)
        item3.title = "iOS"
        item3.price = 50
        
        ad.saveContext()
    }
    
    
    
}
