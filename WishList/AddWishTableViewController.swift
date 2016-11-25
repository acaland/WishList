//
//  AddWishTableViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class AddWishTableViewController: UITableViewController {

    var wishToEdit: Wish!
    var wishStore: WishStore!
    
    @IBOutlet weak var wishNameTextField: UITextField!
    @IBOutlet weak var wishLocationTextField: UITextField!
    @IBOutlet weak var wishPriceTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        if (wishToEdit != nil) {
            wishNameTextField.text = wishToEdit.name
            wishLocationTextField.text = wishToEdit.location
            wishPriceTextField.text = String(describing: wishToEdit.price)
        }
        // cause the keyboard to appear on the first field
        wishNameTextField.becomeFirstResponder()
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        // cause the keyboard to disappear
        tableView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewWish(_ sender: UIBarButtonItem) {
        
        let name = wishNameTextField.text!
        let location = wishLocationTextField.text!
        if let price = Float(wishPriceTextField.text!) {
            if wishToEdit == nil { // we are adding a new wish
                let newWish = Wish(name: name, location: location, price: price, thumbnail: "tahiti")
                wishStore.add(aWish: newWish)
//                performSegue(withIdentifier: "addWish", sender: nil)
            } else { // we are editing an existing wish
                wishToEdit.name = name
                wishToEdit.location = location
                wishToEdit.price = price
//                performSegue(withIdentifier: "editWish", sender: nil)
            }
            performSegue(withIdentifier: "goBack", sender: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You need to set a price", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
