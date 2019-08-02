//
//  AdminDashboard.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 25/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AVFoundation

class AdminDashboard: UIViewController {
    var audioPlayer:AVAudioPlayer?
    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var deleteProduct: UIButton!
    @IBOutlet weak var adminLogo: UIImageView!
    @IBOutlet weak var addPromotions: UIButton!
    @IBOutlet weak var deletePromotion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        
        adminLogo.frame.size = CGSize(width: screenSize.width-50, height: 65)
        deleteProduct.frame.origin = CGPoint(x: screenSize.width/4-5, y: 105)
        
        insertBtn.layer.cornerRadius = 10
        insertBtn.layer.borderWidth = 1
        insertBtn.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        deletePromotion.layer.cornerRadius = 10
        deletePromotion.layer.borderWidth = 1
        deletePromotion.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        deleteProduct.layer.cornerRadius = 10
        deleteProduct.layer.borderWidth = 1
        deleteProduct.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        addPromotions.layer.cornerRadius = 10
        addPromotions.layer.borderWidth = 1
        addPromotions.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        insertBtn.frame.size = CGSize(width: screenSize.width-32, height: 72)
        insertBtn.frame.origin = CGPoint(x: 16, y: 220)
        
        var h = self.insertBtn.frame.size.height + 250
        deleteProduct.frame.size = CGSize(width: screenSize.width-32, height: 72)
        deleteProduct.frame.origin = CGPoint(x: 16, y: h)
        
        h = h + self.deleteProduct.frame.size.height + 30
        deletePromotion.frame.size = CGSize(width: screenSize.width-32, height: 72)
        deletePromotion.frame.origin = CGPoint(x: 16, y: h)
        
        h = h + self.deletePromotion.frame.size.height + 30
        addPromotions.frame.size = CGSize(width: screenSize.width-32, height: 72)
        addPromotions.frame.origin = CGPoint(x: 16, y: h)

        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click1", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Main") as? MainPage {

            self.present(v, animated: true, completion: nil)
        }
        
       
    }
    @IBAction func deleteTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "DeleteProduct") as? DeleteProduct {
            self.present(v, animated: true, completion: nil)
        }
    }
    @IBAction func insertTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "InserProduct") as? InsertProduct {
            self.present(v, animated: true, completion: nil)
        }
    }
    
    @IBAction func addPromotionsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "InsertPromotions") as? InsertPromotions {
            self.present(v, animated: true, completion: nil)
        }
        
    }
    @IBAction func deletePromotionsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "DeletePromotions") as? DeletePromotions {
            self.present(v, animated: true, completion: nil)
        }
    }

}
