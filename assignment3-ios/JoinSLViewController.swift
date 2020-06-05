//
//  JoinSLViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class JoinSLViewController: UIViewController {
    var db:Firestore!
    var shoppingListCode:String?
    
    @IBOutlet weak var joinSLTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBAction func joinShoppingList(_ sender: Any) {
        if !joinSLTextField.text!.isEmpty && checkCodeExist() {
            shoppingListCode = joinSLTextField.text
            print("Both condition made")
        } else if joinSLTextField.text!.isEmpty {
            errorMessage.text = "Error! Textfield empty."
            errorMessage.isHidden = false
        } else {
            errorMessage.text = "Error! Invalid code, try again"
            errorMessage.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        joinButton.applyButtonDesign()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //func prepare for gameViewController
        if let shoppingListVC = segue.destination as? ShoppingListViewController{
                shoppingListVC.shoppingListCode = shoppingListCode ?? ""
        }
    }

    func checkCodeExist() -> Bool {
        var exist:Bool = false
        let docRef = db.collection(UserKeys.firestoreListCollection)
        docRef.getDocuments() { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                if document.documentID == self.joinSLTextField.text {
                   exist = true
                }
            }
        }
        return exist;
    }

}
