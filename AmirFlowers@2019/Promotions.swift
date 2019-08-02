//
//  Promotions.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 01/08/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class Promotions: NSObject {
    
    private var name: String;
    private var picURL: String;
    let key: String
    let itemRef: DatabaseReference?
    
    init(name: String,picURL:String,key: String) {
        self.name = name;
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

        if let url = snapshotValue?["promotionImageURL"] as? String{
            picURL = url
        }else{
            picURL = ""
        }
    }
    public func SetName(name: String) {
        self.name = name;
    }
   
    public func SetPicURL(picURL: String) {
        self.picURL = picURL;
    }
    public func GetName() -> String {
        return self.name;
    }
    
  
    public func GetPicURL() -> String {
        return self.picURL;
    }
    
    public func GetDictionary() -> [String : Any] {
        return ["name" : self.name]
    }
}
