//
//  DeletePromotions.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 01/08/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import AVFoundation


class DeletePromotions: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!

    var promotions = [Promotions]()
    
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
        
        dbRef = Database.database().reference().child("promotions")
        loadDB()
        
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
        dbRef.observe(DataEventType.value, with: {(snapshot) in
            var newPromotions = [Promotions]()
            for productSnapshot in snapshot.children {
                let obj = Promotions(snapshot: productSnapshot as! DataSnapshot)
                
                newPromotions.append(obj)
                
            }
            self.promotions = newPromotions
            self.collectionView.reloadData()
        })
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        
        let h = (self.collectionView.frame.size.height/2.7)/1.5
        
        let promotion = promotions[indexPath.item]
        cell.productLabel.text = promotion.GetName()
        cell.productImageView.frame.size = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: h)
        cell.productLabel.frame.origin = CGPoint(x: 5, y: h+10)
        cell.productImageView.sd_setImage(with: URL(string: promotion.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5

        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        
        let promotionCode = promotions[indexPath.item].key
       
        showAlertWithDistructiveButton(promotionKey: promotionCode)
        
    }
    
    func showAlertWithDistructiveButton(promotionKey: String) {
        let alert = UIAlertController(title: "האם אתה באמת רוצה למחוק את הפריט?", message: "לחץ על מחק כדי למחוק את הפריט", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ביטול", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            return
        }))
        alert.addAction(UIAlertAction(title: "מחק",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        let deleteItem = self.dbRef.child(promotionKey)
                                        
                                        deleteItem.removeValue(completionBlock: { (error, refer) in
                                            if error != nil {
                                                print(error as Any)
                                                
                                            } else {
                                                let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message: "המבצע הסתיים בהצלחה😉", preferredStyle: UIAlertController.Style.alert)
                                                let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
                                                myAlert.addAction(okAction)
                                                self.present(myAlert,animated: true,  completion:nil)
                                                
                                            }
                                            
                                        })
                                        self.loadDB()
                                        
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
