//
//  DeleteProduct.swift
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

class DeleteProduct: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    
    var products = [Product]()
    var audioPlayer:AVAudioPlayer?
    var total:Double = 0
    var dbRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        collectionView.frame.size = CGSize(width: screenSize.width, height: screenSize.height-90)
        collectionView.frame.origin = CGPoint(x: 0, y: 90)

        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 10), height: (self.collectionView.frame.size.height/4))
        
        returnBtn.frame.origin = CGPoint(x: 16, y: 50)
        nameLabel.frame.origin = CGPoint(x: screenSize.width/3, y: 48)
        
        dbRef = Database.database().reference().child("product")
        loadDB()
        
    }
    func loadDB() {
        dbRef.observe(DataEventType.value, with: {(snapshot) in
            var newProducts = [Product]()
            for productSnapshot in snapshot.children {
                let productObj = Product(snapshot: productSnapshot as! DataSnapshot)
                
                newProducts.append(productObj)
                
            }
            self.products = newProducts
            self.collectionView.reloadData()
        })
    }

    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        dismiss(animated: true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        
        var h = (self.collectionView.frame.size.height/4)
        
        let product = products[indexPath.item]
        
        cell.productLabel.text = product.GetName()
        cell.productImageView.frame.size = CGSize(width: (self.collectionView.frame.size.width - 10)/2, height: h)
        h = h/12
        
        cell.productLabel.frame.size = CGSize(width: (self.collectionView.frame.size.width/2 - 20), height: 35)
        cell.priceLabel.frame.size = CGSize(width: (self.collectionView.frame.size.width/2 - 20), height: 35)
        cell.productLabel.frame.origin = CGPoint(x: (self.collectionView.frame.size.width / 2) + 5, y: h)
        h = h + 40
        
        cell.priceLabel.frame.origin = CGPoint(x: (self.collectionView.frame.size.width / 2)+5, y: h)
        h = h + 45
        
        var w = self.collectionView.frame.size.width / 4
        w = self.collectionView.frame.size.width - w
        w = self.collectionView.frame.size.width / w
//
//        cell.trash.frame.size = CGSize(width: 25, height: 25)
//        cell.trash.frame.origin = CGPoint(x: (self.collectionView.frame.size.width - 20)/w, y: h)
        cell.productImageView.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        cell.priceLabel.text = "מחיר: \(product.GetPrice())"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
//
//
//        cell.trash.tag = indexPath.row
//        cell.trash.addTarget(self, action: #selector(trashGroupAction(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        
        let productCode = products[indexPath.item].key
        
        showAlertWithDistructiveButton(productKey: productCode)
        
    }
    
    func showAlertWithDistructiveButton(productKey: String) {
        let alert = UIAlertController(title: "האם אתה באמת רוצה למחוק את הפריט?", message: "לחץ על מחק כדי למחוק את הפריט", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ביטול", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            return
        }))
        alert.addAction(UIAlertAction(title: "מחק", style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        let deleteItem = self.dbRef.child(productKey)
                                        
                                        deleteItem.removeValue(completionBlock: { (error, refer) in
                                            if error != nil {
                                                print(error as Any)
                                                
                                            } else {
                                                let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המוצר נמחק בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
                                                let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
                                                myAlert.addAction(okAction)
                                                self.present(myAlert,animated: true,  completion:nil)
                                                
                                            }
                                            
                                        })
                                        self.loadDB()
                                        
        }))
        self.present(alert, animated: true, completion: nil)
    }
//
//    @objc func trashGroupAction(sender: UIButton) {
//        print("Button \(sender.tag) Clicked")
//        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
//        let url = URL(fileURLWithPath: path)
//        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
//        self.audioPlayer?.prepareToPlay()
//        self.audioPlayer?.play()
//
//        let productCode = products[sender.tag].key
//        print("clicked product id: ", productCode)
//
//        let deleteItem = self.dbRef.child(productCode)
//        deleteItem.removeValue(completionBlock: { (error, refer) in
//            if error != nil {
//                print(error as Any)
//
//            } else {
//                print(refer)
//                print("Child Removed Correctly")
//
//            }
//
//        })
//
//        self.loadDB()
//
//
//    }


}
