//
//  PromotionsInfo.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 01/08/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import FirebaseDatabase
import FirebaseAuth

class PromotionsInfo: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    
    var audioPlayer:AVAudioPlayer?
    var ref = DatabaseReference.init()
    
    var promotion = Promotions(name: "product 1",picURL:"load",key: "key")
    var carts = [Cart]()
    var favorites = [FavoriteProduct]()
    var dbRefCart: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
        img.sd_setImage(with: URL(string: promotion.GetPicURL()), placeholderImage: UIImage(named: "loading"))
        productName.text = promotion.GetName()
        
        let screenSize: CGRect = UIScreen.main.bounds
        returnBtn.frame.origin = CGPoint(x: 16, y: 55)
        productName.frame.origin = CGPoint(x: 50, y: 53)
        productName.frame.size = CGSize(width: screenSize.width-60, height: 30)
        img.frame.size = CGSize(width: screenSize.width, height: screenSize.height-90)
        
        img.frame.origin = CGPoint(x: 0, y: 70)
        
        super.viewDidLoad()
        
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        dismiss(animated: true, completion:nil)
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
