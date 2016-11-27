//
//  AddWishTableViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

protocol AddWishTableViewControllerDelegate: class{
    func addWishTableViewControllerDidCancel()
    func addWishTableViewController(didFinishAdding wish: Wish)
}

class AddWishTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var wishToEdit: Wish!
//    var wishStore: WishStore!
    
    weak var delegate: AddWishTableViewControllerDelegate?
    
    @IBOutlet weak var wishNameTextField: UITextField!
    @IBOutlet weak var wishLocationTextField: UITextField!
    @IBOutlet weak var wishPriceTextField: UITextField!
    @IBOutlet weak var wishImageView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (wishToEdit != nil) {
            wishNameTextField.text = wishToEdit.name
            wishLocationTextField.text = wishToEdit.location
            wishPriceTextField.text = String(describing: wishToEdit.price)
            wishImageView.image = wishToEdit.thumbnail
            wishImageView.contentMode = .scaleAspectFill
        }
        // cause the keyboard to appear on the first field
        wishNameTextField.becomeFirstResponder()
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        // cause the keyboard to disappear
        tableView.endEditing(true)
//        dismiss(animated: true, completion: nil)
        delegate?.addWishTableViewControllerDidCancel()
    }
    
    
    @IBAction func addNewWish(_ sender: UIBarButtonItem) {
        
        let name = wishNameTextField.text!
        let location = wishLocationTextField.text!
        if let price = Float(wishPriceTextField.text!) {
            if wishToEdit == nil { // we are adding a new wish
                let newWish = Wish(name: name, location: location, price: price, thumbnail: wishImageView.image!)
//                wishStore.add(aWish: newWish)
                delegate?.addWishTableViewController(didFinishAdding: newWish)
//                performSegue(withIdentifier: "addWish", sender: nil)
            } else { // we are editing an existing wish
                wishToEdit.name = name
                wishToEdit.location = location
                wishToEdit.price = price
                wishToEdit.thumbnail = wishImageView.image!
//                performSegue(withIdentifier: "editWish", sender: nil)
            }
            performSegue(withIdentifier: "goBack", sender: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You need to set a price", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return indexPath
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
//                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("immagine scelta")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            wishImageView.image = image
            wishImageView.contentMode = .scaleAspectFill
            
        }
        dismiss(animated: true, completion: nil)
    }

}
