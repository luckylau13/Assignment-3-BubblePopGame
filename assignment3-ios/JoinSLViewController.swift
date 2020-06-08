//
//  JoinSLViewController.swift
//  assignment3-ios
//
//  Created by Wen Loong (Ayden) Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class JoinSLViewController: UIViewController {
    var db:Firestore!
    var shoppingListCode:String?
    var codeExist:Bool = false
    
    @IBOutlet weak var joinSLTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        joinButton.applyButtonDesign()
    }
    
    //Check textfield value 
    @IBAction func tFEditingChanged(_ sender: UITextField) {
        if joinSLTextField.text?.count ?? 0 >= 5 {
            checkCodeExist(code: joinSLTextField.text ?? "")
        }
        print("Editing..")
    }
    
    //condition check if Segue should happen
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var segueShouldOccur:Bool = false
        if identifier == "JoinSLtoShoppingListVC" {
            if joinSLTextField.text?.count ?? 0 >= 5 && codeExist{
                segueShouldOccur = true
                print("Both condition made")
            }
            if !segueShouldOccur {
                alertUser(strTitle: "Error", strMessage: "Invalid code! Please try again.", viewController: self)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //func prepare for ShoppingListViewController
        if let shoppingListVC = segue.destination as? ShoppingListViewController{
                shoppingListVC.shoppingListCode = shoppingListCode ?? ""
        }
    }

    func checkCodeExist(code: String){
        print("checking existence")
        codeExist = false
        let docRef = db.collection(UserKeys.firestoreListCollection).document(code)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.codeExist = true
                self.shoppingListCode = code
                print("Exist!")
            }
        }
    }
    
    public func alertUser(strTitle: String, strMessage: String, viewController: UIViewController) {
        let myAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        viewController.present(myAlert, animated: true, completion: nil)
    }

}
