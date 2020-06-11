//
//  CreateSLViewController.swift
//  assignment3-ios
//
//  Created by Wen Loong (Ayden) Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit

class CreateSLViewController: UIViewController {
    var db:Firestore!
    var uniqueCode = ""
    
    @IBOutlet weak var shoppingListTextfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    //create new document in firestore with an array of string ie. items
    @IBAction func createShoppingList(_ sender: Any) {
        let listName = shoppingListTextfield.text ?? "No Name"
        if !listName.isEmpty {
            // Create list document
            db.collection(Keys.firestoreListCollection).document(uniqueCode).setData([
                "listName" : listName
            ])
            
            // Add list code to user
            let userEmail = Firebase.Auth.auth().currentUser?.email ?? "example-user"
            let docRef = db.collection(Keys.firestoreUserCollection).document(userEmail)
            docRef.getDocument { (document, error) in
                let attribute = "lists"
                var lists = document?[attribute] as? [String] ?? [String]()
                lists.append(self.uniqueCode)
                docRef.setData([attribute : lists], merge: true)
            }
        }
    }
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        createButton.applyButtonDesign()
        generateCode()
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //func prepare for ShoppingListViewController
        if let shoppingListVC = segue.destination as? ShoppingListViewController{
                shoppingListVC.shoppingListCode = uniqueCode
        }
    }
    
    //generate code for new shopping list
    func generateCode(){
        let code = generateRandomCode(length: 5)
        checkCodeExist(initialCode: code)
    }
    
    //access "lists" collection, check if generated code exist in the collection
    func checkCodeExist(initialCode: String) {
        var code = initialCode
        self.codeLabel.text = ""
        let docRef = db.collection(Keys.firestoreListCollection)
         
        docRef.getDocuments() { (querySnapshot, error) in
            var notUnique = true // Assume not unique
            while notUnique {
                for document in querySnapshot!.documents {
                    if document.documentID == code {
                        code = self.generateRandomCode(length: 5)
                        notUnique = true
                        break
                    }
                }
                notUnique = false
            }
            self.codeLabel.text = code
            self.uniqueCode = code
        }
    }
    
    //randomly generate alphanumeric string
    func generateRandomCode(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
}


