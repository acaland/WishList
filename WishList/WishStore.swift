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
    
    func filter(searchText: String) -> [Wish] {
        var searchResults: [Wish] = []
        for wish in wishlist {
            if wish.name.localizedCaseInsensitiveContains(searchText) {
                searchResults.append(wish)
            }
        }
        return searchResults
    }
    
}
