//
//  InsertProduct.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 25/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class InsertProduct: UIViewController {

    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pTitle: UITextField!
    @IBOutlet weak var pDesc: UITextField!
    @IBOutlet weak var pCategory: UITextField!
    @IBOutlet weak var pPrice: UITextField!
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var ref = DatabaseReference.init()
    var audioPlayer:AVAudioPlayer?
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        insertBtn.layer.cornerRadius = 5
        insertBtn.layer.borderWidth = 1
        insertBtn.layer.borderColor = UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.9).cgColor
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let screenSize: CGRect = UIScreen.main.bounds
        returnBtn.frame.origin = CGPoint(x: 16, y: 40)
        returnBtn.frame.size = CGSize(width: 25, height:25)
        titlePage.frame.origin = CGPoint(x: screenSize.width/2.8, y: 35)
        
        productImageView.frame.size = CGSize(width: (screenSize.width-60), height:260)
        productImageView.frame.origin = CGPoint(x: 30, y: 30)
        
        var h = self.productImageView.frame.size.height + 50
        name.frame.size = CGSize(width: (screenSize.width-60), height:30)
        name.frame.origin = CGPoint(x: 30, y: h)
        
        h=h+50
        pTitle.frame.size = CGSize(width: (screenSize.width-60), height:30)
        pTitle.frame.origin = CGPoint(x: 30, y: h)
        
        h=h+50
        pDesc.frame.size = CGSize(width: (screenSize.width-60), height:30)
        pDesc.frame.origin = CGPoint(x: 30, y: h)
        
        h=h+50
        pCategory.frame.size = CGSize(width: (screenSize.width-60), height:30)
        pCategory.frame.origin = CGPoint(x: 30, y: h)
        
        h=h+50
        pPrice.frame.size = CGSize(width: (screenSize.width-60), height:30)
        pPrice.frame.origin = CGPoint(x: 30, y: h)
        
        h=h+50
        insertBtn.frame.size = CGSize(width: (screenSize.width-240), height:30)
        insertBtn.frame.origin = CGPoint(x: 120, y: h)
        
        scrollView.frame.size = CGSize(width: (screenSize.width), height:(screenSize.height-100))
         scrollView.frame.origin = CGPoint(x: 0, y: 50)
        
        toolBar.frame.size = CGSize(width: (screenSize.width  ), height: 50)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        name.inputAccessoryView = toolBar
        pTitle.inputAccessoryView = toolBar
        pDesc.inputAccessoryView = toolBar
        pCategory.inputAccessoryView = toolBar
        pPrice.inputAccessoryView = toolBar
        
       
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(InsertProduct.openGallery(tapGesture:)))
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func doneClicked (){
        
        view.endEditing(true)
    }
    @objc func openGallery(tapGesture: UITapGestureRecognizer){
        self.setypImagePicker()
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click1", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        dismiss(animated: true, completion:nil)
    }
    @IBAction func insertProduct(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click3", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        self.saveFIRData()
    }
    func saveFIRData(){
        if( (self.productImageView.image! != UIImage(named: "upload_image")) && String(self.name.text! ) != "" && String(self.pTitle.text! ) != "" && String(self.pDesc.text! ) != "" && String(self.pCategory.text! ) != "" && String(self.pPrice.text! ) != ""  ){
            self.uploadImage(self.productImageView.image!){ url in
                
                self.saveProduct(name: self.name.text!, title: self.pTitle.text!, desc: self.pDesc.text!, category: self.pCategory.text!, price: Double(self.pPrice.text!)!, productURL: url!) { success in
                    print("sss\(String(describing: success))")
                    if success != nil {
                        return
                    }
                }
            }
            
        }else{
            let myAlert = UIAlertController(title: "failed ❌", message: "יש למלא כל הפרטים", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert,animated: true,  completion:nil)
        }
      
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
         self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}

extension InsertProduct: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setypImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        productImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}

extension InsertProduct {
    
    func uploadImage(_ image: UIImage, complition: @escaping (_ url: URL?) -> () ){
        let storageRef = Storage.storage().reference().child("Image-\(name.text!)")
        let imgData = productImageView.image?.pngData()
        let metData = StorageMetadata()
        metData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metData) { (metData,error) in
            if error == nil {
                let myAlert = UIAlertController(title: "Success ✅", message: "Image Saved Successfully 😉", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
               
                storageRef.downloadURL(completion: { (url, error) in
                    complition(url!)
                })
                 return
            }else{
                print("error in save image\(String(describing: error))")
                complition(nil)
                
            }
        }
    }
    
    func saveProduct(name: String,title: String, desc: String , category: String , price: Double, productURL: URL, complition: @escaping ((_ url: URL?) -> ()) ) {
        let dict = ["name": name, "title": title, "description": desc, "category": category, "price": price, "productURL": productURL.absoluteString ] as [String : Any]
        self.ref.child("product").childByAutoId().setValue(dict)
        
    }
}
