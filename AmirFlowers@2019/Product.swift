//
//  Product.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 25/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Product: NSObject {
    
    private var name: String;
    private var title: String;
    private var desc: String;
    private var price: Double;
    private var category: String;
    private var picURL: String;
    
    let key: String
    let itemRef: DatabaseReference?
    init(name: String, title: String, desc: String, price: Double ,category: String,picURL:String,key: String) {
        self.name = name;
        self.title = title;
        self.desc = desc;
        self.price = price;
        self.category = category;
        self.picURL = picURL;
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
        
        if let t = snapshotValue?["title"] as? String{
            title = t
        }else{
            title = ""
        }
        
        if let d = snapshotValue?["description"] as? String{
            desc = d
        }else{
            desc = ""
        }
        
        if let c = snapshotValue?["category"] as? String{
            category = c
        }else{
            category = ""
        }
        if let p = snapshotValue?["price"] as? Double{
            price = p
        }else{
            price = 0
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
    public func SetTitle(title: String) {
        self.title = title;
    }
    
    public func SetDesc(desc: String) {
        self.desc = desc;
    }
    public func SetCategory(category: String) {
        self.category = category;
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
    
    public func GetTitle() -> String {
        return self.title;
    }
    public func GetDesc() -> String {
        return self.desc;
    }
    public func GetCategory() -> String {
        return self.category;
    }
    public func GetPrice() -> Double {
        return self.price;
    }
    public func GetPicURL() -> String {
        return self.picURL;
    }
    
    public func GetDictionary() -> [String : Any] {
        return ["name" : self.name,
                "title" : self.title,
                "desc" : self.desc,
                "category" : self.category,
                "price" : self.price]
    }
    
}
