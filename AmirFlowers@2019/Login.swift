//
//  Login.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 18/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import AVFoundation

class Login: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var audioPlayer:AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let screenSize: CGRect = UIScreen.main.bounds
        

        
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.9).cgColor
        loginBtn.showsTouchWhenHighlighted = true
        
        let emailImage = UIImage(named: "email")
        addLeftImageTo(txtField: txtEmail, andImage: emailImage!)
        
        let passwordImage = UIImage(named: "password")
        addLeftImageTo(txtField: txtPassword, andImage: passwordImage!)
        
        toolBar.frame.size = CGSize(width: (screenSize.width  ), height: 50)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar
    }
    @objc func doneClicked (){
        
        view.endEditing(true)
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click5", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let v = storyboard.instantiateViewController(withIdentifier: "Signup") as? Signup {
            self.present(v, animated: true, completion: nil)
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click4", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
            if user != nil {
                if self.txtEmail.text != "info2019@amirflowers.com"{
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
            if error != nil {
                let myAlert = UIAlertController(title: "Alert❗️", message: "Error\(String(describing: error?.localizedDescription)) ", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert,animated: true,  completion:nil)
                return
            }
        }
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "click1", ofType: "mp3")else{return}
        let url = URL(fileURLWithPath: path)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
        
        dismiss(animated: true, completion:nil)

    }
    func addLeftImageTo(txtField: UITextField , andImage img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 1.0, y: 1.0, width: img.size.width/1.5, height: img.size.height/1.5))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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
