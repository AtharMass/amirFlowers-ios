//
//  favorite.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 31/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import AVFoundation

class favorite: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!

    
    
    var products = [Product]()
    var carts = [Cart]()
    var favorites = [FavoriteProduct]()
    
    var audioPlayer:AVAudioPlayer?
    
   
    var dbRef: DatabaseReference!
    
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
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: (self.collectionView.frame.size.height/2.7))
        
        returnBtn.frame.origin = CGPoint(x: 16, y: 50)
        nameLabel.frame.origin = CGPoint(x: screenSize.width/3, y: 48)
        
        dbRef = Database.database().reference().child("favorite")
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
    
    func loadDB() {
        var emailUser : String = ""

        if (Auth.auth().currentUser?.email) == nil {
            emailUser = (UIDevice.current.identifierForVendor?.uuidString)!
        }else{
            emailUser =  ((Auth.auth().currentUser?.email)!)
        }
        
        dbRef.queryOrdered(byChild: "email").queryEqual(toValue: emailUser).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            var newFavorites = [FavoriteProduct]()
            
            if snapshot.exists() {
                print("exists")
                
                for productSnapshot in snapshot.children {
                    let productObj = FavoriteProduct(snapshot: productSnapshot as! DataSnapshot)
                    
                    newFavorites.append(productObj)
                    
                }
                self.favorites = newFavorites
            }
            else {
                print("doesn't exist")
            }
            self.favorites = newFavorites
            
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        
        var h = (self.collectionView.frame.size.height/2.7)/1.5
        
        let product = favorites[indexPath.item]
        cell.productLabel.text = product.GetName()
        cell.productImageView.frame.size = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: h)
        cell.productLabel.frame.origin = CGPoint(x: 5, y: h+10)
        cell.priceLabel.frame.origin = CGPoint(x: 5, y: h+40)
        cell.productImageView.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        cell.priceLabel.text = "מחיר: \(product.GetPrice())"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5

        h = (self.collectionView.frame.size.height/2.7)/12
        
        cell.removeFrom.frame.size = CGSize(width: 25, height: 25)
        cell.removeFrom.frame.origin = CGPoint(x: 10, y: 10)

        cell.removeFrom.tag = indexPath.row
        cell.removeFrom.addTarget(self, action: #selector(trashGroupAction(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func trashGroupAction(sender: UIButton) {
        print("Button \(sender.tag) Clicked")
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let productCode = favorites[sender.tag].key
        print("clicked product id: ", productCode)
        
        let deleteItem = self.dbRef.child(productCode)
        deleteItem.removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error as Any)
                
            } else {
                let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המוצר נמחק מהמועדפים בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
                
            }
            
        })
        
        self.loadDB()
        
        
    }


}
