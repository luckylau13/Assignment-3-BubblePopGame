//
//  ShoppingListViewController.swift
//  TestTableView
//
//  Created by Vong Beng on 3/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ShoppingListViewController: UIViewController {
    var db : Firestore!
    var listener : ListenerRegistration!
    var newItemTextField = UITextField()
    var addItemButton = UIButton()
    
    var shoppingListTableView = UITableView()
    var shoppingList = [ListItem]()
    var shoppingListCode = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.shoppingList.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        title = "Shopping List"
        addComponents()
        configureTableView()
        configureAddComponents()
        loadListData()
        addListener()
        // Do any additional setup after loading the view.
    }
    
    func addComponents() {
        addItemButton = UIButton.init(type: .roundedRect)
        addItemButton.setTitle("Add", for: .normal)
        addItemButton.addTarget(self, action: #selector(addItem(_ :)), for: .touchUpInside)
        addItemButton.backgroundColor = .systemGreen
        addItemButton.layer.cornerRadius = 5
        addItemButton.setTitleColor(.white, for: .normal)
        
        newItemTextField.borderStyle = .roundedRect
        newItemTextField.placeholder = "Add item"
        
        view.addSubview(addItemButton)
        view.addSubview(newItemTextField)
    }
    
    // TextField and Add Button Constraints
    func configureAddComponents() {
        newItemTextField.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        newItemTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15).isActive = true
        newItemTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        newItemTextField.trailingAnchor.constraint(equalTo: addItemButton.leadingAnchor, constant: -15).isActive = true
        
        addItemButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15).isActive = true
        addItemButton.leadingAnchor.constraint(equalTo: newItemTextField.trailingAnchor, constant: 15).isActive = true
        addItemButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -15).isActive = true
    }

    @objc func addItem(_ : UIButton) {
        let itemName = newItemTextField.text ?? ""
        if !itemName.isEmpty {
            let newItem = ListItem(itemName, completed: false)
            
            db
            .collection(Keys.firestoreListCollection)
            .document(shoppingListCode)
            .collection(Keys.firestoreItemsSubcollection)
            .addDocument(data: newItem.dictionary)
        }
    }
    
    // TableView Constraints
    func configureTableViewConstraints() {
        shoppingListTableView.translatesAutoresizingMaskIntoConstraints = false
        shoppingListTableView.topAnchor.constraint(equalTo: addItemButton.bottomAnchor, constant: 15).isActive = true
        shoppingListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        shoppingListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        shoppingListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func configureTableView() {
        // Add to subview
        view.addSubview(shoppingListTableView)
        // Set delegate
        setDelegateAndDataSource()
        // Set row height
        shoppingListTableView.rowHeight = 80
        // Register cells
        shoppingListTableView.register(ShoppingListCell.self, forCellReuseIdentifier: Cell.identifier)
        // Pin Table constraints to superview edges
        configureTableViewConstraints()
    }
    
    // Set ShoppingListVC as delegat and data source for the table view
    func setDelegateAndDataSource() {
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
    }
}

extension ShoppingListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! ShoppingListCell
        let listItem = shoppingList[indexPath.row]
        cell.setupCell(item: listItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Toggle Completed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = shoppingList[indexPath.row]
        
        let cell = shoppingListTableView.cellForRow(at: indexPath) as! ShoppingListCell
        let itemID = item.id
        
        item.completed.toggle()
        print(item.completed)
        cell.updateStatusImage(item: item) // Update checkmark
        let newStatus = item.completed
        
        // Reference to item in list
        let itemRef = getItemRef(itemID)
        // Update data on Firestore
        itemRef.updateData([
            "completed" : newStatus
        ])
    }
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let item = shoppingList.remove(at: row)
            
            self.shoppingListTableView.beginUpdates()
            self.shoppingListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.shoppingListTableView.endUpdates()
            
            let itemID = item.id
            
            let itemRef = getItemRef(itemID)
            itemRef.delete()
        }
    }
    
    func getItemRef(_ itemID : String) -> DocumentReference {
        return db
            .collection(Keys.firestoreListCollection)
            .document(shoppingListCode)
            .collection(Keys.firestoreItemsSubcollection)
            .document(itemID)
    }
}

extension ShoppingListViewController {
    struct Cell {
        static let identifier = "ItemCell"
    }
    
    func loadListData() {
        let listRef = db.collection(Keys.firestoreListCollection).document(shoppingListCode)
        
        listRef.getDocument { (doc, err) in
            if let actualDocument = doc, actualDocument.exists {
                self.title = actualDocument.data()?["listName"] as? String ?? "Untitled List"
            }
        }
        
        listRef
            .collection(Keys.firestoreItemsSubcollection)
            .getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.shoppingList = querySnapshot!.documents.compactMap({ListItem($0.documentID,from: $0.data())})
                    DispatchQueue.main.async {
                        self.shoppingListTableView.reloadData()
                    }
                }
            }
    }
    
    func addListener() {
        listener = db
        .collection(Keys.firestoreListCollection)
        .document(shoppingListCode)
        .collection(Keys.firestoreItemsSubcollection)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    return
                }
                
                snapshot.documentChanges.forEach { difference in
                    let id = difference.document.documentID
                    if difference.type == .added {
                        self.shoppingList.append(ListItem(difference.document.documentID, from: difference.document.data()))
                        DispatchQueue.main.async {
                            self.shoppingListTableView.reloadData()
                        }
                    } else {
                        for index in 0 ..< self.shoppingList.count {
                            if self.shoppingList[index].id == id {
                                if difference.type == .removed {
                                    self.shoppingList.remove(at: index)
                                    let animation = UITableView.RowAnimation.automatic
                                    self.shoppingListTableView.beginUpdates()
                                    self.shoppingListTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: animation)
                                    self.shoppingListTableView.endUpdates()
                                    break
                                } else if difference.type == .modified {
                                    let oldItem = self.shoppingList[index]
                                    let newItem = difference.document.data()
                                    let newTitle = newItem["title"] as? String ?? "New Name Error"
                                    let newStatus = newItem["completed"] as? Bool ?? false
                                    oldItem.title = newTitle
                                    oldItem.completed = newStatus
                                    let cell = self.shoppingListTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! ShoppingListCell
                                    cell.updateStatusImage(item: oldItem)
                                }
                            }
                        }
                    }
                }
        }
    }
}
