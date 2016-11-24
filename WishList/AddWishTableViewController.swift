//
//  AddWishTableViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class AddWishTableViewController: UITableViewController {

    var newWish: Wish!
    
    @IBOutlet weak var wishNameTextField: UITextField!
    @IBOutlet weak var wishLocationTextField: UITextField!
    @IBOutlet weak var wishPriceTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        if (newWish != nil) {
            wishNameTextField.text = newWish.name
            wishLocationTextField.text = newWish.location
            wishPriceTextField.text = String(describing: newWish.price)
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
            if newWish == nil { // we are adding a new wish
                newWish = Wish(name: name, location: location, price: price, thumbnail: "tahiti")
                performSegue(withIdentifier: "addWish", sender: nil)
            } else { // we are editing an existing wish
                newWish.name = name
                newWish.location = location
                newWish.price = price
                performSegue(withIdentifier: "editWish", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "You need to set a price", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }


}
