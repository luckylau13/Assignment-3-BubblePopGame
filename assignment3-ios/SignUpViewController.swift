//
//  SignUpViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.applyButtonDesign()
        // Do any additional setup after loading the view.
    }
    
    //check the field and validate that the data is correct if everything is correct this method return nill otherwise it shows error message.
    
    //for password verification
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields(){
        
        // check that all fiedls are filled in
        if firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            alertUser(strTitle: "Error", strMessage: "Please fill in all the fields!", viewController: self)
        }
        //Check if email is correct format.
        
        //check if password is secure.
        let cleanedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if SignUpViewController.isPasswordValid(cleanedPassword) == false{
            //return "Please make sure your password is at least 8 charachers, contains a special character and a number."
            alertUser(strTitle: "Error", strMessage: "Please make sure your password is at least 8 charachers, contains a special character and a number.! Please try again.", viewController: self)
        }
        
    }
    
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        //validate the field
        
        //crate cleaned versions of the data
        let firstnameT = firstname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastnameT = lastname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailT = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordT = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPasswordT = confirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //create user
        Auth.auth().createUser(withEmail: emailT, password: passwordT) { (result, err) in
            
            //check for error
            if err != nil{
                self.alertUser(strTitle: "Error", strMessage: "Unable to create account please contact system administrator. Please make sure that you fill in all the details.", viewController: self)
            }
            else{
                //User was created successfully, now store the first name and last name
                let user = Auth.auth().currentUser
                if let user = user{
                    //let uid = user.uid
                    let emails = user.email ?? "example-user"
                    let db = Firestore.firestore()
                    db.collection("users").document(emails).setData([
                        "firstName": firstnameT,
                        "lastName": lastnameT
                    ]){
                        err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else{
                            print("Document successfully written!")
                        }
                    }

                }
                
                self.transitionToHome()
                }
            
            }
    }
        
        
    //transition to the login screen
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
                    
    }
    
    //alert if error
    public func alertUser(strTitle: String, strMessage: String, viewController: UIViewController) {
           let myAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           myAlert.addAction(okAction)
           viewController.present(myAlert, animated: true, completion: nil)
       }

    
    

}
