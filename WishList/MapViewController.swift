//
//  MapViewController.swift
//  WishList
//
//  Created by Antonio Calanducci on 28/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var currentWish: Wish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        title = currentWish.name
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(currentWish.location, completionHandler: { placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = self.currentWish.name
                annotation.subtitle = self.currentWish.location + " " + String(describing: self.currentWish.price) + " Euro"
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height:53))
        leftIconView.image = currentWish.thumbnail
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.blue
        annotationView?.animatesDrop = true
        
        return annotationView
        
    }

}
