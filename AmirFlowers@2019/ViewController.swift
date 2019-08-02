//
//  ViewController.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 11/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let products = ["Product 1","Product 2","Product 3","Product 4","Product 5"]
    
    let productsPrices = ["100","150","200","120","170"]

    let productsImages : [UIImage] = [
        UIImage(named: "Product 1")!,
        UIImage(named: "Product 2")!,
        UIImage(named: "Product 3")!,
        UIImage(named: "Product 4")!,
        UIImage(named: "Product 5")!,
    ]
    
     var audioPlayer:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: (self.collectionView.frame.size.height/2.8))
        // Do any additional setup after loading the view, typically from a nib.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        cell.productLabel.text = products[indexPath.item]
        cell.productImageView.image = productsImages[indexPath.item]
        cell.priceLabel.text = "מחיר: \(productsPrices[indexPath.item])"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell

    }

}

