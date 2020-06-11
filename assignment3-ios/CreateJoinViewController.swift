//
//  CreateJoinViewController.swift
//  assignment3-ios
//
//  Created by Wen Loong (Ayden) Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class CreateJoinViewController: UIViewController {
    var db:Firestore!
    var email : String!
    let defaults = UserDefaults.standard
    
    var ownedLists : [OwnedList] = [OwnedList]()
    
    var ownedListTableView = UITableView()
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var createSLButton: UIButton!
    @IBOutlet weak var joinSLButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ownedLists.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOwnedListsTableView()
        db = Firestore.firestore()
        createSLButton.applyButtonDesign()
        joinSLButton.applyButtonDesign()
        navigationItem.hidesBackButton = true
    }
    
    //Using UserDefault for userID to load user FirstName from firestore
    func loadUserData(){
        userLabel.text = ""
        email = defaults.string(forKey: Keys.userID_Key) ?? "example-user"
        let userDocRef = getUserDocRef()
        userDocRef.getDocument { (document, error) in
            if let userFirstName = document?.get("firstName") as? String {
                self.userLabel.text = "Hey, \(userFirstName)"
            } else {
                self.userLabel.text = "Hi Unnamed User"
            }
            let listsOwned = document?.get("lists") as? [String] ?? [String]()
            for listID in listsOwned {
                    self.db.collection(Keys.firestoreListCollection).document(listID).getDocument { (listDocument, listError) in
                    let listName = listDocument?.get("listName") as? String ?? "Untitled List"
                    let ownedList = OwnedList(id: listID, name: listName)
                    self.ownedLists.append(ownedList)
                    DispatchQueue.main.async {
                        self.ownedListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getUserDocRef() -> DocumentReference {
         return db.collection(Keys.firestoreUserCollection).document(email)
    }
    
}

extension UIButton {
    func applyButtonDesign() {
        self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.layer.cornerRadius = 25.0
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

extension CreateJoinViewController : UITableViewDelegate, UITableViewDataSource {
    
    struct Cell {
        static let identifier = "ListCell"
    }
    
    func configureOwnedListsTableView() {
        view.addSubview(ownedListTableView)
        
        setDelegateAndDataSource()
        
        ownedListTableView.rowHeight = 50
        
        ownedListTableView.register(OwnedListCell.self, forCellReuseIdentifier: Cell.identifier)
        
        setOwnedListsTableViewConstraints()
    }
    
    func setOwnedListsTableViewConstraints() {
        ownedListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        ownedListTableView.topAnchor.constraint(equalTo: joinSLButton.bottomAnchor, constant: 20).isActive = true
        ownedListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        ownedListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ownedListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func setDelegateAndDataSource() {
        ownedListTableView.delegate = self
        ownedListTableView.dataSource = self
    }
    
    // Configure amount of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ownedLists.count
    }
    
    // Set up each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! OwnedListCell
        let listItem = ownedLists[indexPath.row]
        cell.setupCell(list: listItem)
        return cell
    }
    
    // Delete items
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let listID = ownedLists.remove(at: row).id
            let userDocRef = getUserDocRef()
            
            self.ownedListTableView.beginUpdates()
            self.ownedListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.ownedListTableView.endUpdates()
            
            userDocRef.updateData([
                "lists" : FieldValue.arrayRemove([listID])
            ])
        }
    }
    
    // Handle cell clicks
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showList", sender: nil)
    }
    
    // Deselect row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Set title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Created Lists"
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedID = ownedListTableView.indexPathForSelectedRow?.row else {
            return
        }
        if let target = segue.destination as? ShoppingListViewController {
            if selectedID < self.ownedLists.count {
                target.shoppingListCode = ownedLists[selectedID].id
            }
        }
    }
}
