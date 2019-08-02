//
//  MainPage.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 16/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore
import AVFoundation
import MessageUI
import MapKit
import CoreLocation

class MainPage: UIViewController, MFMessageComposeViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
   
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var profile: UIButton!
    
    @IBOutlet weak var arrangementsBtn: UIButton!
    @IBOutlet weak var bouquetsBtn: UIButton!
    @IBOutlet weak var pottedBtn: UIButton!
    @IBOutlet weak var bridalBouquetsBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var signInLabel: UIButton!
    @IBOutlet weak var logoutLogo: UIButton!
    @IBOutlet weak var profileLogo: UIButton!
    @IBOutlet weak var balloonsBtn: UIButton!
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var carDecorationBtn: UIButton!
    @IBOutlet weak var giftsBtn: UIButton!
    @IBOutlet weak var fruitBtn: UIButton!
    @IBOutlet weak var chocolatesBtn: UIButton!
    
    @IBOutlet weak var slider: UICollectionView!
    
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var marker: UIButton!
    @IBOutlet weak var message: UIButton!
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var cartShopping: UIButton!
    
    var audioPlayer:AVAudioPlayer?
    
    let sliderImages = [
        UIImage(named: "amirflowers1"),
        UIImage(named: "amirflowers2"),
        UIImage(named: "amirflowers3"),
        ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.numberOfPages = sliderImages.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        logout.isHidden = true

        login.layer.cornerRadius = 5
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.9).cgColor
        login.showsTouchWhenHighlighted = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        slider.frame.size = CGSize(width: (screenSize.width-4), height: 180)
        slider.frame.origin = CGPoint(x: 2, y:80)
        
         let topH = screenSize.width - (view.safeAreaLayoutGuide.layoutFrame.size.height + 20)
        print("topH\(topH)")
        logo.frame.origin = CGPoint(x: (screenSize.width-16-114), y: 45)
        
        profileLogo.frame.origin = CGPoint(x: 60, y: 45)
        logoutLogo.frame.origin = CGPoint(x: 16, y: 45)
        signInLabel.frame.origin = CGPoint(x: 16, y: 45)
        
        let wB = (screenSize.width)/2.0
        let xB = 2+(screenSize.width)/2
        let hB = (screenSize.height-340)/5.0
        var yB:Float = 262.0
        bouquetsBtn.frame.size = CGSize(width: wB, height: hB)
        bouquetsBtn.frame.origin = CGPoint(x: 2, y: Int(yB))
        arrangementsBtn.frame.size = CGSize(width: wB, height: hB)
        arrangementsBtn.frame.origin = CGPoint(x: xB+2, y: CGFloat(yB))
        
        yB = yB + Float(hB) + 2.0
        bridalBouquetsBtn.frame.size = CGSize(width: wB, height: hB)
        bridalBouquetsBtn.frame.origin = CGPoint(x: 2, y: Int(yB))
        pottedBtn.frame.size = CGSize(width: wB, height: hB)
        pottedBtn.frame.origin = CGPoint(x: xB+2, y: CGFloat(yB))
        
        yB = yB + Float(hB) + 2.0
        balloonsBtn.frame.size = CGSize(width: wB, height: hB)
        balloonsBtn.frame.origin = CGPoint(x: 2, y: Int(yB))
        eventBtn.frame.size = CGSize(width: wB, height: hB)
        eventBtn.frame.origin = CGPoint(x: xB+2, y: CGFloat(yB))
        
        yB = yB + Float(hB) + 2.0
        carDecorationBtn.frame.size = CGSize(width: wB, height: hB)
        carDecorationBtn.frame.origin = CGPoint(x: 2, y: Int(yB))
        giftsBtn.frame.size = CGSize(width: wB, height: hB)
        giftsBtn.frame.origin = CGPoint(x: xB+2, y: CGFloat(yB))
        
        yB = yB + Float(hB) + 2.0
        fruitBtn.frame.size = CGSize(width: wB, height: hB)
        fruitBtn.frame.origin = CGPoint(x: 2, y: Int(yB))
        chocolatesBtn.frame.size = CGSize(width: wB, height: hB)
        chocolatesBtn.frame.origin = CGPoint(x: xB+2, y: CGFloat(yB))
        
        let widthFor = screenSize.width / 6
        var w = (widthFor - cartShopping.frame.size.width)/2
        yB = yB + Float(chocolatesBtn.frame.size.height) + 10
        cartShopping.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        w = w + cartShopping.frame.size.width + (widthFor - cartShopping.frame.size.width)
        favorite.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        w = w + cartShopping.frame.size.width + (widthFor - cartShopping.frame.size.width)
        call.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        w = w + cartShopping.frame.size.width + (widthFor - cartShopping.frame.size.width)
        message.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        w = w + cartShopping.frame.size.width + (widthFor - cartShopping.frame.size.width)
        marker.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        w = w + cartShopping.frame.size.width + (widthFor - cartShopping.frame.size.width)
        facebook.frame.origin = CGPoint(x:  Int(w), y: Int(yB))
        
        if Auth.auth().currentUser != nil {
            
            // User is signed in.
            login.isHidden = true
            logout.isHidden = false
            profile.isHidden = false
        } else {
            // No user is signed in.
             login.isHidden = false
             logout.isHidden = true
             profile.isHidden = true
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // function sendMessage to send a message to manager of store
    func sendMessage(){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
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
    
    // function callTo to call to manager of store
    func callTo(){
        guard let number = URL(string: "tel://" + "0523800212") else { return }
        UIApplication.shared.open(number)
    }
    
    // function onclick chocolates button
    @IBAction func chocolatesTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Chocolates") as? Chocolates {
            self.present(v, animated: true, completion: nil)
        }
    }
    
    // function onclick cart shopping button
    @IBAction func cartTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "ShoppingCart") as? ShoppingCart {
            self.present(v, animated: true, completion: nil)
        }
    }
    
    // function onclick favorite button
    @IBAction func favoriteTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "favorite") as? favorite {
            self.present(v, animated: true, completion: nil)
        }
    }
    
     // function onclick call to call
    @IBAction func callTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
//        let myAlert = UIAlertController(title: "failed ❌", message: "המכשיר לא יכול לבצע הפעולה", preferredStyle: UIAlertController.Style.alert)
//
//        let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
//
//        myAlert.addAction(okAction)
//
//        self.present(myAlert,animated: true,  completion:nil)
        callTo()
    }
    
     // function onclick message to send a message
    @IBAction func messageTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        sendMessage()
    }
    
    // function onclick marker location to open the navigation
    @IBAction func markerTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let latitude:Float = 32.257800
        let longitude:Float = 35.005465
        
        let location =  CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        openWaze(location : location)

    }
    
    //Function to open Waze and navigate to the store location
    func openWaze(location : CLLocationCoordinate2D) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://app")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
             print("App installed")
            UIApplication.shared.open(URL(string: urlStr)!)
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
//            print("App not installed")
//            let myAlert = UIAlertController(title: "failed ❌", message: "המכשיר לא יכול לבצע הפעולה", preferredStyle: UIAlertController.Style.alert)
//
//            let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
//
//            myAlert.addAction(okAction)
            
//            self.present(myAlert,animated: true,  completion:nil)
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    //Function to open FACEBOOK Page
    @IBAction func facebookTapped(_ sender: Any) {
        
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let fbURLWeb: NSURL = NSURL(string: "https://www.facebook.com/Amir.Flowers2/")!
        let fbURLID: NSURL = NSURL(string: "fb://profile/1575599072765936")!
        
        
        if(UIApplication.shared.canOpenURL(fbURLID as URL)){
            // FB installed
            UIApplication.shared.open(fbURLID as URL )
        } else {
            // FB is not installed, open in safari
             UIApplication.shared.open(fbURLWeb as URL)
           
        }
    }
    
    // function onclick gifts button
    @IBAction func giftsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Gifts") as? Gifts {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick balloons button
    @IBAction func balloonsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Balloons") as? Balloons {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick bridal bouquets button
    @IBAction func bridalBouquetsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "BridalBouquets") as? BridalBouquets {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick arrangements button
    @IBAction func arrangementsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Arrangements") as? Arrangements {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick fruit button
    @IBAction func fruitTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Fruit") as? Fruit {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick car decoration button
    @IBAction func carDecorationsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "CarDecorations") as? CarDecorations {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick event design button
    @IBAction func eventDesignTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "EventDesign") as? EventDesign {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick potted button
    @IBAction func pottedTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Potted") as? Potted {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick bouquets button
    @IBAction func bouquetsTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Bouquets") as? Bouquets {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick logout button
    @IBAction func logoutTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            login.isHidden = false
            logout.isHidden = true
            profile.isHidden = true
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    // function onclick profile button
    @IBAction func profileTapped(_ sender: Any) {
        
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            
            if email != "info2019@amirflowers.com"{
                print("user has signed up!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let v = storyboard.instantiateViewController(withIdentifier: "UserDashboard") as? UserDashboard {
                    self.present(v, animated: true, completion: nil)
                }
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let v = storyboard.instantiateViewController(withIdentifier: "AdminDashboard") as? AdminDashboard {
                    self.present(v, animated: true, completion: nil)
                }
            }
        }
    }
    // function onclick signup button
    @IBAction func signupTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Signup") as? Signup {
            self.present(v, animated: true, completion: nil)
        }
    }
    // function onclick login button
    @IBAction func loginTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click1", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "Login") as? Login {
            self.present(vc, animated: true, completion: nil)
        }
    }
    // function to change image on slider
    @objc func changeImage() {
        
        if counter < sliderImages.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   

}

extension MainPage : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = sliderImages[indexPath.row]
        }
        return cell
    }
}

extension MainPage : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
