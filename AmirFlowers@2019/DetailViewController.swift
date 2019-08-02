//
//  DetailViewController.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 18/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var descProduct: UITextView!
    
     var audioPlayer:AVAudioPlayer?
    
    var product = Product(name: "product 1", title: "product title", desc: "product description", price: 100.00 ,category: "product category",picURL:"Product 1",key: "key")
    
    override func viewDidLoad() {
        print("product \(product)")
        img.sd_setImage(with: URL(string: product.GetPicURL()), placeholderImage: UIImage(named: "Product 1"))
        productName.text = product.GetName()
        price.text = "מחיר: \(product.GetPrice())"
        category.text =  "קטגוריה: \( product.GetCategory())"
        descProduct.text = "תיאור: \(product.GetDesc())"
        
        let screenSize: CGRect = UIScreen.main.bounds
        returnBtn.frame.origin = CGPoint(x: 16, y: 55)
        productName.frame.origin = CGPoint(x: screenSize.width/2.7, y: 53)
        
        var h = (self.img.frame.size.height)
        
        
//        productImageView.frame.size = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: h)
        price.frame.origin = CGPoint(x: 16, y: h+190)
        h = h + 55
        category.frame.origin = CGPoint(x: 16, y: h)
        h = h + 55
        descProduct.frame.origin = CGPoint(x: 16, y: h)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
