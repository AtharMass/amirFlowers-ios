//
//  FavoriteProducts.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class FavoriteProduct: NSObject {
    
    private var name: String
    private var price: Double
    private var picURL: String
    private var userEmail:String
    private var productKey:String
    let key: String
    let itemRef: DatabaseReference?
    
    init(name: String,  price: Double ,userEmail: String,picURL:String,productKey: String, key: String) {
        self.name = name;
        self.price = price;
        self.userEmail = userEmail;
        self.picURL = picURL;
        self.productKey = productKey;
        self.key = key
        self.itemRef = nil
    }
    
    init(snapshot: DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let n = snapshotValue?["name"] as? String{
            name = n
        }else{
            name = ""
        }
        
        if let p = snapshotValue?["price"] as? Double{
            price = p
        }else{
            price = 0
        }
        
        if let email = snapshotValue?["userEmail"] as? String{
            userEmail = email
        }else{
            userEmail = ""
        }
        
        if let pKey = snapshotValue?["productKey"] as? String{
            productKey = pKey
        }else{
            productKey = ""
        }
        
        if let url = snapshotValue?["productURL"] as? String{
            picURL = url
        }else{
            picURL = ""
        }
    }
    public func SetName(name: String) {
        self.name = name;
    }
    public func SetProductKey(productKey: String) {
        self.productKey = productKey;
    }
    public func SetUser(user: String) {
        self.userEmail = user;
    }
    public func SetPrice(price: Double) {
        self.price = price;
    }
    public func SetPicURL(picURL: String) {
        self.picURL = picURL;
    }
    public func GetName() -> String {
        return self.name;
    }
    public func GetProductKey() -> String {
        return self.productKey;
    }
    public func GetUser() -> String {
        return self.userEmail;
    }
    public func GetPrice() -> Double {
        return self.price;
    }
    public func GetPicURL() -> String {
        return self.picURL;
    }
    
    public func GetDictionary() -> [String : Any] {
        return ["name" : self.name,
                "userName": self.userEmail,
                "productKey": self.productKey,
                "price" : self.price]
    }
}



