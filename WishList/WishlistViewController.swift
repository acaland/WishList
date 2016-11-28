//
//  WishlistViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, AddWishTableViewControllerDelegate {

    var wishStore: WishStore!
    var searchResults: [Wish] = []
    var searchController: UISearchController!
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        wishStore.add(aWish: Wish(name: "Fligth to Tahiti", location: "Tahiti Polinesia Francese", price: 4000.0, thumbnail: UIImage(named: "tahiti")!))
        wishStore.add(aWish: Wish(name: "Macbook Pro 13", location: "Via Curiel 25, Rozzano", price: 2500.0, thumbnail: UIImage(named: "macbookpro")!))
        wishStore.add(aWish: Wish(name: "Fender Stratocaster", location: "Via San Sebastiano, Napoli", price: 1500.00, thumbnail: UIImage(named: "stratocaster")!))
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            let addWishVC = segue.destination as! AddWishTableViewController
            addWishVC.navigationItem.leftBarButtonItem = nil
            addWishVC.title = "Edit wish"
            addWishVC.navigationItem.rightBarButtonItem?.title = "Update"
            addWishVC.wishToEdit = wishStore.wish(at: (tableView.indexPathForSelectedRow?.row)!)
        } else if segue.identifier == "addWish" {
            let navigationController = segue.destination as! UINavigationController
            let addWishVC = navigationController.topViewController as! AddWishTableViewController
//            addWishVC.wishStore = wishStore
            addWishVC.delegate = self
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return wishStore.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishCellType", for: indexPath) as! WishTableViewCell
        
        let theWish = searchController.isActive ? searchResults[indexPath.row] : wishStore.wish(at: indexPath.row)!
        cell.nameLabel.text = theWish.name
        cell.locationLabel.text = theWish.location
        cell.priceLabel.text = String(describing: theWish.price)
        cell.thumbnailImageView.image = theWish.thumbnail
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
                (action, indexPath) in

                self.wishStore.deleteWish(at: indexPath.row)
                // delete the row from the tableview
                //self.tableView.reloadData()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: {
                (action, indexPath) in
//                let message = "My wish for this Xmas is \(self.wishlist[indexPath.row].name)"
                let theWish = self.wishStore.wish(at: indexPath.row)
                let message = "I would to receive a \(theWish!.name)"
                let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
        })
        shareAction.backgroundColor = UIColor.blue
        
        return [deleteAction, shareAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedWish = wishStore.wish(at: sourceIndexPath.row)
        wishStore.deleteWish(at: sourceIndexPath.row)
        wishStore.add(aWish: movedWish!, at: destinationIndexPath.row)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("the search text is \(searchController.searchBar.text!)")
        if let searchText = searchController.searchBar.text {
            searchResults = wishStore.filter(text: searchText)
            tableView.reloadData()
        }
    }
    
    
    func addWishTableViewControllerDidCancel() {
        print("AddWishTVController has been cancelled")
    }
    
    func addWishTableViewController(didFinishAdding wish: Wish) {
        wishStore.add(aWish: wish)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func returnToHome(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func toggleEditMode(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            // revert to not editing mode
            tableView.setEditing(false, animated: true)
            // let's change the title of the edit button to Edit
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode(_:)))
        } else {
            tableView.setEditing(true, animated: true)
             // let's change the title of the edit button to Done
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditMode(_:)))
        }
    }
}



