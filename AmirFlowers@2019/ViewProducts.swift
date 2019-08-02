//
//  ViewProducts.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 27/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import AVFoundation

class ViewProducts: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    
    var products = [Product]()
    
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
        
        returnBtn.frame.origin = CGPoint(x: 16, y: 55)
        nameLabel.frame.origin = CGPoint(x: screenSize.width/3, y: 50)
        dbRef = Database.database().reference().child("product")
        loadDB()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click1", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
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
        if let v = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
          
       
            v.product = products[indexPath.item]
            print(v.product)
            self.present(v, animated: true, completion: nil)
        }
        
    }

}
