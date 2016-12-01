//
//  Wish.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class Wish: NSObject, NSCoding {
    var name: String
    var location: String
    var price: Float 
    var thumbnail: UIImage?
    
    init(name: String, location: String, price: Float, thumbnail: UIImage) {
        self.name = name
        self.location = location
        self.price = price
        self.thumbnail = thumbnail
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(UIImageJPEGRepresentation(thumbnail!, 0.5), forKey: "thumbnail")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.price = aDecoder.decodeFloat(forKey: "price")
        let imageData = aDecoder.decodeObject(forKey: "thumbnail") as! Data 
        self.thumbnail = UIImage(data: imageData)
    }
    
    
}
