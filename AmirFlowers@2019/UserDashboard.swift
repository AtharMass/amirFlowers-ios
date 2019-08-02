//
//  UserDashboard.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 15/07/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import  FirebaseDatabase
import AVFoundation

class UserDashboard: UIViewController {

    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var myCart: UIButton!
    @IBOutlet weak var myFavorite: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var promotions: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        logo.frame.size = CGSize(width: screenSize.width-50, height: 65)
        myFavorite.frame.origin = CGPoint(x: screenSize.width/4-5, y: 105)
        
        myCart.layer.cornerRadius = 10
        myCart.layer.borderWidth = 1
        myCart.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        promotions.layer.cornerRadius = 10
        promotions.layer.borderWidth = 1
        promotions.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        myFavorite.layer.cornerRadius = 10
        myFavorite.layer.borderWidth = 1
        myFavorite.layer.borderColor =  UIColor.init(red: 20/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        
        myCart.frame.size = CGSize(width: screenSize.width-32, height: 72)
        myCart.frame.origin = CGPoint(x: 16, y: 270)
        
        var h = self.myCart.frame.size.height + 300
        myFavorite.frame.size = CGSize(width: screenSize.width-32, height: 72)
        myFavorite.frame.origin = CGPoint(x: 16, y: h)
        h = h + self.promotions.frame.size.height + 30
        promotions.frame.size = CGSize(width: screenSize.width-32, height: 72)
        promotions.frame.origin = CGPoint(x: 16, y: h)
        
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
    
    @IBAction func myFavoriteTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "favorite") as? favorite {
            self.present(v, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func promotionsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "ViewPromotions") as? ViewPromotions {
            self.present(v, animated: true, completion: nil)
        }
    }
    @IBAction func myCartTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
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
