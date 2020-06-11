//
//  LoginViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase


class LoginViewController: UIViewController {

    
    
    var db:Firestore!
    var loginSuccessful:Bool = false
    
    @IBOutlet weak var username: UITextField! //using email
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.applyButtonDesign()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginSuccessful = false
    }
    
    
    @IBAction func logintapped(_ sender: Any) {
        
        //validate text fields
        let email = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordT = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //crate cleaned version
        
        //sign in the user
        Auth.auth().signIn(withEmail: email, password: passwordT) {
            (result, error) in
            
            if error != nil{
                self.alertUser(strTitle: "Error", strMessage: "Unable to login. Incorrect password or username.", viewController: self)
            }
            else{
                self.loginSuccessful = true
                let user = Auth.auth().currentUser
                if let user = user {
                    //let uid = user.uid
                    let emails = user.email ?? "example-user"
                    let defaults = UserDefaults.standard
                    defaults.set(emails, forKey: Keys.userID_Key)
                    let email = defaults.string(forKey: Keys.userID_Key) ?? "example-user"
                    print(email)
                }
                self.performSegue(withIdentifier: "loginToJoinViewSegue", sender: self)
            }
        }
    }
    
    //loginToJoinViewSegue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       var segueShouldOccur:Bool = false
       if identifier == "loginToJoinViewSegue" {
           if loginSuccessful{
               segueShouldOccur = true
           }
           if !segueShouldOccur {
               return false
           }
       }
       return true
   }
    
    //alert if error
    public func alertUser(strTitle: String, strMessage: String, viewController: UIViewController) {
           let myAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           myAlert.addAction(okAction)
           viewController.present(myAlert, animated: true, completion: nil)
   }
    

}
