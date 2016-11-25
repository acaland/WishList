//
//  Wish.swift
//  WishList
//
//  Created by Antonio Calanducci on 23/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import UIKit

class Wish {
    var name: String
    var location: String
    var price: Float 
    var thumbnail: String
    
    init(name: String, location: String, price: Float, thumbnail: String) {
        self.name = name
        self.location = location
        self.price = price
        self.thumbnail = thumbnail
    }
}
