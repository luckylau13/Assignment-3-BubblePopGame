//
//  CreateSLViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class CreateSLViewController: UIViewController {
    var db:Firestore!
    
    @IBOutlet weak var shoppingListTextfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    //create new document in firestore with an array of string ie. items
    @IBAction func createShoppingList(_ sender: Any) {
        let shoppingList : [String : Any] = [
            "listName" : shoppingListTextfield.text ?? "No Name",
            "items" : [String]()
        ]
//        db.collection(UserKeys.firestoreListCollection).document(generateCode()).setData(shoppingList)
    }
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        createButton.applyButtonDesign()
        generateCode()
    }
    
    
    //generate code for new shopping list
    func generateCode(){
        let code = "ueCjU"//generateRandomCode(length: 5)
        checkCodeExist2(initialCode: code)
    }
    
    func checkCodeExist2(initialCode: String) {
        var code = initialCode
        let docRef = db.collection(UserKeys.firestoreListCollection)
        docRef.document(code).getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    code = self.generateRandomCode(length: 5)
                    self.codeLabel.text = code
                } else {
                    print("Code does not exist")
                }
            }
        }
    }
    
     //access "lists" collection and check if generated code exist in the collection
     func checkCodeExist(initialCode: String) {
        var code = initialCode
        let docRef = db.collection(UserKeys.firestoreListCollection)
        
        docRef.getDocuments() { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                if document.documentID == code {
                    code = self.generateRandomCode(length: 5)
                }
            }
            self.codeLabel.text = code
        }
    }
    
    //randomly generate alphanumeric string
    func generateRandomCode(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
}
