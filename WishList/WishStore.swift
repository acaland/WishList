//
//  WishStore.swift
//  WishList
//
//  Created by Antonio Calanducci on 24/11/2016.
//  Copyright © 2016 Antonio Calanducci. All rights reserved.
//

import Foundation

class WishStore {
    private var wishlist: [Wish] = []
    
    var count: Int {
        return wishlist.count
    }
    
    func add(aWish: Wish) {
        wishlist.append(aWish)
    }
    
    func add(aWish: Wish, at index: Int) {
        wishlist.insert(aWish, at: index)
    }
    
    func wish(at index: Int) -> Wish? {
        if index < wishlist.count {
            return wishlist[index]
        } else {
            return nil
        }
    }
    
    func deleteWish(at index: Int) {
        if index < wishlist.count {
            wishlist.remove(at: index)
        }
    }
    
    func filter(text: String) -> [Wish] {
        var results: [Wish] = []
        for wish in wishlist {
            if wish.name.localizedCaseInsensitiveContains(text) {
                results.append(wish)
            }
        }
        return results
    }
    
    init() {
        print("Loading wishlist from \(wishlistArchiveURL().path)")
        // load the wishlist from a file
        
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: wishlistArchiveURL().path) as? [Wish] {
            wishlist = data
        }
    }
    
    func saveWishlist() {
        UserDefaults.standard.set(true, forKey: "isDataAlreadySaved")
        NSKeyedArchiver.archiveRootObject(wishlist, toFile: self.wishlistArchiveURL().path)
        print("wishlist saved to the file")
    }
    
    func wishlistArchiveURL() -> URL {
        let documentPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentPaths[0].appendingPathComponent("wishlist.plist")
    }
    
 }
