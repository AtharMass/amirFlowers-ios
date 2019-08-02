//
//  BalloonsDetail.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 21/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage
import AVFoundation
import FirebaseDatabase

class BalloonsDetail: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var cart: UIButton!
    @IBOutlet weak var badgeNumberIcon: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var descriptionProduct: UITextView!
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var heartColored: UIButton!
    
    var audioPlayer:AVAudioPlayer?
    var dbRefCart: DatabaseReference!
    var ref = DatabaseReference.init()
    
    var carts = [Cart]()
    var favorites = [FavoriteProduct]()
    var product = Product(name: "product 1", title: "product title", desc: "product description", price: 100.00 ,category: "product category",picURL:"Product 1",key: "key")
    
    override func viewDidLoad() {
        self.ref = Database.database().reference()

        img.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        productName.text = product.GetName()
        price.text = "מחיר: \(product.GetPrice())"
        category.text =  "קטגוריה: \( product.GetCategory())"
        descriptionProduct.text = "תיאור: \(product.GetDesc())"
        
        let screenSize: CGRect = UIScreen.main.bounds
        returnBtn.frame.origin = CGPoint(x: 16, y: 55)
        productName.frame.origin = CGPoint(x: screenSize.width/2.7, y: 53)
        
        var h = (self.img.frame.size.height)
        
        addToCart.layer.cornerRadius = 10
        addToCart.layer.borderWidth = 1
        addToCart.layer.borderColor = UIColor.init(red: 0/250, green:122/250, blue: 250/250, alpha: 1).cgColor
        addToCart.showsTouchWhenHighlighted = true
        
        h = h+120
        price.frame.origin = CGPoint(x: 16, y: h)
        h = h + 45
        category.frame.origin = CGPoint(x: 16, y: h)
        h = h + 50
        descriptionProduct.frame.size = CGSize(width: screenSize.width-30, height: 100)
        descriptionProduct.frame.origin = CGPoint(x: 16, y: h)
        h = h + 35 + descriptionProduct.frame.size.height
        addToCart.frame.origin = CGPoint(x: screenSize.width/2.7, y: h)
        
        heart.frame.origin = CGPoint(x: 16, y: h-5)
        heartColored.frame.origin = CGPoint(x: 16, y: h-5)
        
        
        cart.frame.size = CGSize(width: 30, height: 30)
        cart.frame.origin = CGPoint(x: screenSize.width-60, y: 50)
        badgeNumberIcon.frame.origin = CGPoint(x: screenSize.width-32, y: 43)
        badgeNumberIcon.frame.size = CGSize(width: 20, height: 20)
        badgeNumberIcon.isHidden = true
        dbRefCart = Database.database().reference().child("cart")
        badgeNumberCart()
        
        isAlreadyExists(keyProduct: product.key)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func badgeNumberCart()  {
        var emailUser : String = ""
        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        dbRefCart.queryOrdered(byChild: "email").queryEqual(toValue: emailUser).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            var newProducts = [Cart]()
            
            if snapshot.exists() {
                print("exists")
                
                for productSnapshot in snapshot.children {
                    let productObj = Cart(snapshot: productSnapshot as! DataSnapshot)
                    
                    
                    print(productSnapshot)
                    newProducts.append(productObj)
                    
                }
                self.carts = newProducts
                print(self.carts.count )
                if self.carts.count > 0 {
                    self.badgeNumberIcon.isHidden = false
                    self.badgeNumberIcon.layer.cornerRadius = self.badgeNumberIcon.frame.width/2
                    self.badgeNumberIcon.layer.borderWidth = 1
                    self.badgeNumberIcon.layer.borderColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 1).cgColor
                    if self.carts.count <= 99{
                        self.badgeNumberIcon.text = String(self.carts.count)
                        self.badgeNumberIcon.font = self.badgeNumberIcon.font.withSize(16)
                    }else{
                        self.badgeNumberIcon.text = "99"
                        self.badgeNumberIcon.font.withSize(11)
                    }
                }
            }
            else {
                print("doesn't exist")
            }
            self.carts = newProducts
        }
    }
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        dismiss(animated: true, completion:nil)
    }
    @IBAction func addToFavorite(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click3", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        heart.isHidden = true
        heartColored.isHidden = false
        
        self.saveToFavorite()
        
        let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המוצר הוסף למעודפים בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated: true,  completion:nil)
    }
    
    @IBAction func removeFromFavorite(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click3", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        heart.isHidden = false
        heartColored.isHidden = true
        
        self.removeFromFavorite()
        
        let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המוצר נמחק מהמועדפים בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated: true,  completion:nil)
    }
    @IBAction func addToCartTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click3", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        self.saveFIRData()
        badgeNumberCart()
        let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המוצר הוסף לסל בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated: true,  completion:nil)
    }
    func saveFIRData(){
        var emailUser : String = ""
        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        self.saveProductToCart(name: product.GetName(),  price: product.GetPrice(),userEmail: emailUser, productURL: URL(string: product.GetPicURL())!){ success in
            if success != nil {
                let myAlert = UIAlertController(title: "Success ✅", message: "Product Inserted Successfully 😉", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
                
                
                return
            }
        }
        
    }
    
    func saveProductToCart(name: String, price: Double,userEmail: String ,productURL: URL, complition: @escaping ((_ url: URL?) -> ()) ) {
        let dict = ["name": name, "price": price,"email": userEmail, "productURL": productURL.absoluteString ] as [String : Any]
        self.ref.child("cart").childByAutoId().setValue(dict)
        
    }
    
    func saveToFavorite(){
        var emailUser : String = ""
        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        self.saveProductToFavorite(name: product.GetName(),  price: product.GetPrice(),productKey: product.key,userEmail: emailUser, productURL: URL(string: product.GetPicURL())!){ success in
            if success != nil {
                let myAlert = UIAlertController(title: "Success ✅", message: "Product Inserted Successfully 😉", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
                
                
                return
            }
        }
        
    }
    
    func saveProductToFavorite(name: String, price: Double,productKey: String,userEmail: String ,productURL: URL, complition: @escaping ((_ url: URL?) -> ()) ) {
        let dict = ["name": name, "price": price,"email": userEmail,"productKey": productKey, "productURL": productURL.absoluteString ] as [String : Any]
        self.ref.child("favorite").childByAutoId().setValue(dict)
        
    }
    
    func removeFromFavorite(){
        self.removeProductFromFavorite(keyProduct: product.key){ success in
            if success != nil {
                let myAlert = UIAlertController(title: "Success ✅", message: "Product Inserted Successfully 😉", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
                
                
                return
            }
        }
        
    }
    
    func removeProductFromFavorite(keyProduct: String, complition: @escaping ((_ url: URL?) -> ()) ) {
        
        var emailUser : String = ""
        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        ref.child("favorite")
            .queryOrdered(byChild: "email").queryEqual(toValue: emailUser)
            .observeSingleEvent(of: DataEventType.value) { (snapshot) in
                var newProducts = [FavoriteProduct]()
                
                if snapshot.exists() {
                    print("exists")
                    
                    for productSnapshot in snapshot.children {
                        let productObj = FavoriteProduct(snapshot: productSnapshot as! DataSnapshot)
                        if productObj.GetProductKey() == keyProduct{
                            print(productSnapshot)
                            newProducts.append(productObj)
                            let deleteItem  = self.ref.child("favorite").child(productObj.key)
                            deleteItem.removeValue(completionBlock: { (error, refer) in
                                if error != nil {
                                    print(error as Any)
                                    
                                } else {
                                    print("Child Removed Correctly")
                                    
                                }
                                
                            })
                        }
                        
                        
                    }
                    self.favorites = newProducts
                    
                }
                else {
                    print("doesn't exist")
                }
                self.favorites = newProducts
        }
        
    }
    func isAlreadyExists(keyProduct: String){
        var emailUser : String = ""
        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        ref.child("favorite")
            .queryOrdered(byChild: "email").queryEqual(toValue: emailUser)
            .observeSingleEvent(of: DataEventType.value) { (snapshot) in
                var newProducts = [FavoriteProduct]()
                
                if snapshot.exists() {
                    print("exists")
                    
                    for productSnapshot in snapshot.children {
                        let productObj = FavoriteProduct(snapshot: productSnapshot as! DataSnapshot)
                        if productObj.GetProductKey() == keyProduct{
                            print(productSnapshot)
                            newProducts.append(productObj)
                            self.heart.isHidden = true
                            self.heartColored.isHidden = false
                        }else{
                            self.heart.isHidden = false
                            self.heartColored.isHidden = true
                        }
                        
                        
                    }
                    self.favorites = newProducts
                    
                }
                else {
                    print("doesn't exist")
                    self.heart.isHidden = false
                    self.heartColored.isHidden = true
                }
                self.favorites = newProducts
        }
    }
    @IBAction func cartTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click3", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart {
            self.present(v, animated: true, completion: nil)
        }
    }
}
