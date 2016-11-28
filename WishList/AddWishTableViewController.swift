//
//  AddWishTableViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit
import MapKit

protocol AddWishTableViewControllerDelegate: class {
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
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        if (wishToEdit != nil) {
            wishNameTextField.text = wishToEdit.name
            wishLocationTextField.text = wishToEdit.location
            wishPriceTextField.text = String(describing: wishToEdit.price)
            wishImageView.image = wishToEdit.thumbnail
            wishImageView.contentMode = .scaleAspectFill
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
            mapView.addGestureRecognizer(tapGestureRecognizer)
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(wishToEdit.location, completionHandler: {
                placemarks, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    let annotation = MKPointAnnotation()
                   
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        
//                        var center = CLLocationCoordinate2D(latitude: 15.0, longitude: 17.0)
                        
                        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                        self.mapView.setRegion(region, animated: false)
                    }
                }
            
            })
        }
        wishNameTextField.becomeFirstResponder()
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
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            wishImageView.image = newImage
            self.wishImageView.contentMode = .scaleAspectFill
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.currentWish = wishToEdit
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        tableView.endEditing(true)
        dismiss(animated: true, completion: nil)
        delegate?.addWishTableViewControllerDidCancel()
    }
    
    
    @IBAction func addNewWish(_ sender: UIBarButtonItem) {
        
        if let name = wishNameTextField.text, let location = wishLocationTextField.text, let price = Float(wishPriceTextField.text!) {
            if wishToEdit == nil { // we are adding a new wish
                let newWish = Wish(name: name, location: location, price: price, thumbnail: wishImageView.image!)
//                wishStore.add(aWish: newWish)
                delegate?.addWishTableViewController(didFinishAdding: newWish)
            } else { // we are editing an existing wish
                wishToEdit.name = name
                wishToEdit.location = location
                wishToEdit.price = price
                wishToEdit.thumbnail = wishImageView.image!
            }
            performSegue(withIdentifier: "goBack", sender: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You need to set all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
