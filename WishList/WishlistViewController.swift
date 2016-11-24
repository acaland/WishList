//
//  WishlistViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var wishlist: [Wish] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        wishlist = [
            Wish(name: "Fligth to Tahiti", location: "Tahiti", price: 4000.0, thumbnail: "tahiti"),
            Wish(name: "Macbook Pro 13", location: "Apple Store", price: 2500.0, thumbnail: "macbookpro"),
            Wish(name: "Fender Stratocaster", location: "Via San Sebastiano", price: 1500.00, thumbnail: "stratocaster")
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            let addWishVC = segue.destination as! AddWishTableViewController
            addWishVC.navigationItem.leftBarButtonItem = nil
            addWishVC.title = "Edit wish"
            addWishVC.navigationItem.rightBarButtonItem?.title = "Update"
            addWishVC.newWish = wishlist[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishCellType", for: indexPath) as! WishTableViewCell
        cell.nameLabel.text = wishlist[indexPath.row].name
        cell.locationLabel.text = wishlist[indexPath.row].location
        cell.priceLabel.text = String(describing: wishlist[indexPath.row].price)
        cell.thumbnailImageView.image = UIImage(named: wishlist[indexPath.row].thumbnail)
        return cell
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "DummyCell")
//        cell.textLabel?.text = wishlist[indexPath.row].name
//        cell.imageView?.image = UIImage(named: wishlist[indexPath.row].thumbnail)
        //return cell
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "showWishDetail" {
//            let detailVC = segue.destination as! AddWishTableViewController
//            detailVC.title = "edit wish"
//            detailVC.newWish = wishlist[(tableView.indexPathForSelectedRow?.row)!]
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
                (action, indexPath) in
                // delete the selected Wish from array
                self.wishlist.remove(at: indexPath.row)
                // delete the row from the tableview
                //self.tableView.reloadData()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: {
                (action, indexPath) in
                let message = "My wish for this Xmas is \(self.wishlist[indexPath.row].name)"
                let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
        })
        shareAction.backgroundColor = UIColor.blue
        
        return [deleteAction, shareAction]
    }
    
    
    @IBAction func addNewWish(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addWish" {
            let addNewWishVC = segue.source as! AddWishTableViewController
            wishlist.append(addNewWishVC.newWish)
            tableView.reloadData()
        }
        
        print("we got back from the add new wish View Controller")
    }
    
    @IBAction func editWish(segue: UIStoryboardSegue) {
        //print("editing wish")
        // get the updated value of newWish from the segue.source VC?????
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tempWish = wishlist[sourceIndexPath.row]
        wishlist.remove(at: sourceIndexPath.row)
        wishlist.insert(tempWish, at: destinationIndexPath.row)
        //<#code#>
    }
    
    @IBAction func toggleEditMode(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            // revert to not editing mode
            tableView.setEditing(false, animated: true)
            // let's change the title of the edit button to Edit
//            sender.title = "Edit"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode(_:)))
        } else {
            tableView.setEditing(true, animated: true)
             // let's change the title of the edit button to Done
//            sender.title = "Done"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditMode(_:)))
        }
        
    }
    
    
}


