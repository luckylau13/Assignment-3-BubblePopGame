//
//  ForgetPasswordViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func send(_ sender: Any) {
        let resetemail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //reset password
        Auth.auth().sendPasswordReset(withEmail: resetemail) { error in
            if error != nil{
                print("error reseting password")
            }
            else{
                print("password reset")
                self.trasitionToHome()
            }
        
        }
    }
    
    func trasitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
                    
    }
    
    
}
