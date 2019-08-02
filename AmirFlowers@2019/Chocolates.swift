//
//  Chocolates.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 14/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import AVFoundation
import FirebaseAuth

class Chocolates: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var cart: UIButton!
    @IBOutlet weak var badgeNumberIcon: UILabel!
    
    var products = [Product]()
    var carts = [Cart]()
    
    let productsPrices = ["100","150","200","120","170"]
    var audioPlayer:AVAudioPlayer?
    
    let productsImages : [UIImage] = [
        UIImage(named: "Product 1")!,
        UIImage(named: "Product 2")!,
        UIImage(named: "Product 3")!,
        UIImage(named: "Product 4")!,
        UIImage(named: "Product 5")!,
        ]
    var dbRef: DatabaseReference!
    var dbRefCart: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let screenSize: CGRect = UIScreen.main.bounds
        collectionView.frame.size = CGSize(width: screenSize.width, height: screenSize.height-90)
        collectionView.frame.origin = CGPoint(x: 0, y: 90)
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: (self.collectionView.frame.size.height/2.5))
        
        returnBtn.frame.origin = CGPoint(x: 16, y: 50)
        nameLabel.frame.origin = CGPoint(x: screenSize.width/3, y: 48)
        
        cart.frame.size = CGSize(width: 30, height: 30)
        cart.frame.origin = CGPoint(x: screenSize.width-60, y: 50)
        badgeNumberIcon.frame.origin = CGPoint(x: screenSize.width-32, y: 43)
        badgeNumberIcon.frame.size = CGSize(width: 20, height: 20)
        badgeNumberIcon.isHidden = true
        dbRefCart = Database.database().reference().child("cart")
        badgeNumberCart()
        
        dbRef = Database.database().reference().child("product")
        loadDB()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        dismiss(animated: true, completion:nil)
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
                    self.collectionView.reloadData()
                }
            }
            else {
                print("doesn't exist")
            }
            self.carts = newProducts
            
            self.collectionView.reloadData()
        }
    }
    func loadDB() {
        dbRef.queryOrdered(byChild: "category").queryEqual(toValue: "שקולדים").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            var newProducts = [Product]()
            
            if snapshot.exists() {
                print("exists")
                
                for productSnapshot in snapshot.children {
                    let productObj = Product(snapshot: productSnapshot as! DataSnapshot)
                    
                    
                    print(productSnapshot)
                    newProducts.append(productObj)
                    
                }
                self.products = newProducts
            }
            else {
                print("doesn't exist")
            }
            
            
            self.products = newProducts
            self.collectionView.reloadData()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        let h = (self.collectionView.frame.size.height/2.7)/1.5
        let product = products[indexPath.item]
        cell.productLabel.text = product.GetName()
        cell.productImageView.frame.size = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: h)
        cell.productLabel.frame.origin = CGPoint(x: 5, y: h+10)
        cell.priceLabel.frame.origin = CGPoint(x: 5, y: h+40)
        cell.productImageView.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        cell.priceLabel.text = "מחיר: \(product.GetPrice())"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        
        //        cell.productLabel.text = products[indexPath.item]
        //        cell.productImageView.image = productsImages[indexPath.item]
        //        cell.priceLabel.text = "מחיר: \(productsPrices[indexPath.item])"
        //        cell.layer.borderColor = UIColor.lightGray.cgColor
        //        cell.layer.borderWidth = 0.5
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "ChocolatesDetail") as? ChocolatesDetail {
            
            
            v.product = products[indexPath.item]
            print(v.product)
            self.present(v, animated: true, completion: nil)
        }
        
    }

}
