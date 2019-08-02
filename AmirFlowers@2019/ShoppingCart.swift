//
//  ShoppingCart.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 30/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import AVFoundation
import MessageUI

class ShoppingCart: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, MFMessageComposeViewControllerDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var cart: UIButton!
    @IBOutlet weak var badgeNumberIcon: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var checkout: UIButton!
   
    
    
    var carts = [Cart]()
    var audioPlayer:AVAudioPlayer?
    var total:Double = 0
    var dbRefCart: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let screenSize: CGRect = UIScreen.main.bounds
        collectionView.frame.size = CGSize(width: screenSize.width, height: screenSize.height-150)
        collectionView.frame.origin = CGPoint(x: 0, y: 90)
        
        price.frame.size = CGSize(width: screenSize.width/3, height: 50)
        price.frame.origin = CGPoint(x: screenSize.width/2.8, y: self.collectionView.frame.size.height+90)
        
        labelTotal.frame.size = CGSize(width: screenSize.width/3, height: 50)
        checkout.frame.origin = CGPoint(x: 16, y: self.collectionView.frame.size.height+93)
        
        checkout.frame.size = CGSize(width: screenSize.width/4, height: 40)
        labelTotal.frame.origin = CGPoint(x: self.checkout.frame.size.width + self.price.frame.size.width + 24, y: self.collectionView.frame.size.height+90)
        
        checkout.layer.cornerRadius = 5
        checkout.layer.borderWidth = 1
        checkout.layer.borderColor = UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 10), height: (self.collectionView.frame.size.height/4))
        
        returnBtn.frame.origin = CGPoint(x: 16, y: 50)
        nameLabel.frame.origin = CGPoint(x: screenSize.width/3, y: 48)
        
        cart.frame.size = CGSize(width: 30, height: 30)
        cart.frame.origin = CGPoint(x: screenSize.width-60, y: 50)
        badgeNumberIcon.frame.origin = CGPoint(x: screenSize.width-32, y: 43)
        badgeNumberIcon.frame.size = CGSize(width: 20, height: 20)
        badgeNumberIcon.isHidden = true
        dbRefCart = Database.database().reference().child("cart")
        badgeNumberCart()
        self.price.text = "0.00 ₪"
    }
    func badgeNumberCart()  {
        
        var emailUser : String = ""
        
        self.total = 0.0
        
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
                }else{
                    self.badgeNumberIcon.isHidden = true
                }
                for product in self.carts {
                    self.total = self.total + product.GetPrice()
                    
                }
               
                self.price.text = "\(self.total) ₪"
                
            }
            else {
                print("doesn't exist")
            }
            self.carts = newProducts
            print("\(self.carts.count) count")
            if self.carts.count == 0 {
                self.badgeNumberIcon.isHidden = true
                self.price.text = "0.00 ₪"
            }
            self.collectionView.reloadData()
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

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func checkout(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        func printActionTitle(_ action: UIAlertAction) {
            print("לחצת על  \(action.title!)")
            if action.title! == "חייג"{
                callTo()
            }else{
                if action.title! == "שלח הודעה" {
                    sendMessage()
                }else{
                    if action.title! == "הזמן דרך האתר" {
                        sendToWEB()
                    }
                }
            }
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "חייג", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "הזמן דרך האתר", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "שלח הודעה", style: .destructive, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "ביטול", style: .cancel, handler: printActionTitle))
        self.present(alertController, animated: true, completion: nil)
    }
    func callTo(){
        guard let number = URL(string: "tel://" + "0523800212") else
        {
          
                let myAlert = UIAlertController(title: "failed ❌", message: "המכשיר לא יכול לבצע הפעולה", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
           
            return
            
        }
        UIApplication.shared.open(number)
    }
    func sendMessage(){
        var n:String = ""
        var p:Double = 0.0
        var messageContent:String = "הפרטים שאני מזמין"
        for product in self.carts {
           n = product.GetName()
           p = product.GetPrice()
            messageContent = "\(messageContent) \n שם המוצר: \(n) , מחיר המוצר: \(p) "
        }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = messageContent
            controller.recipients = ["0523800212"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            let myAlert = UIAlertController(title: "failed ❌", message: "המכשיר לא יכול לבצע הפעולה", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert,animated: true,  completion:nil)
        }
    }
    func sendToWEB(){
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let fbURLWeb: NSURL = NSURL(string: "https://www.amirflowers.co.il")!
        
        UIApplication.shared.open(fbURLWeb as URL)

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        
        var h = (self.collectionView.frame.size.height/4)
        
        let product = carts[indexPath.item]
        
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
        
        cell.trash.frame.size = CGSize(width: 25, height: 25)
        cell.trash.frame.origin = CGPoint(x: (self.collectionView.frame.size.width - 20)/w, y: h)
        cell.productImageView.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        cell.priceLabel.text = "מחיר: \(product.GetPrice())"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        
        cell.trash.tag = indexPath.row
        cell.trash.addTarget(self, action: #selector(trashGroupAction(sender:)), for: .touchUpInside)
        

        return cell
        
    }
    
    @objc func trashGroupAction(sender: UIButton) {

        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let productCode = carts[sender.tag].key

        confirmDelete(promotionKey: productCode)
        
        
       
    }
    
    func confirmDelete(promotionKey: String) {
        let alert = UIAlertController(title: "האם אתה באמת רוצה למחוק את הפריט?", message: "לחץ על מחק כדי למחוק את הפריט", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ביטול", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
            let url = URL(fileURLWithPath: path)
            self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            self.audioPlayer?.prepareToPlay()
            return
        }))
        alert.addAction(UIAlertAction(title: "מחק",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        let deleteItem = self.dbRefCart.child(promotionKey)
                                        
                                        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
                                        let url = URL(fileURLWithPath: path)
                                        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
                                        self.audioPlayer?.prepareToPlay()
                                        
                                        deleteItem.removeValue(completionBlock: { (error, refer) in
                                            if error != nil {
                                                print(error as Any)
                                                
                                            } else {
                                                let myAlert = UIAlertController(title: "הפעולה בוצעה בהצלחה ✅", message:  "המוצר נמחק בהצלחה 😉", preferredStyle: UIAlertController.Style.alert)
                                                let okAction = UIAlertAction(title: "בסדר", style: UIAlertAction.Style.default,handler:nil)
                                                myAlert.addAction(okAction)
                                                self.present(myAlert,animated: true,  completion:nil)
                                                
                                            }
                                            
                                        })
                                        self.badgeNumberCart()
                                        
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
