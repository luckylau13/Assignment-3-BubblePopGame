//
//  ShoppingListViewController.swift
//  TestTableView
//
//  Created by Vong Beng on 3/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {

    var newItemTextField = UITextField()
    var addItemButton = UIButton()
    var shoppingListTableView = UITableView()
    var shoppingList = [ListItem]()
    var shoppingListCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        addComponents()
        configureTableView()
        configureAddComponents()
        getList()
        // Do any additional setup after loading the view.
    }
    
    func addComponents() {
        addItemButton = UIButton.init(type: .roundedRect)
        addItemButton.setTitle("+", for: .normal)
        addItemButton.addTarget(self, action: #selector(addItem(_ :)), for: .touchUpInside)
        view.addSubview(addItemButton)
        view.addSubview(newItemTextField)
    }
    
    func configureAddComponents() {
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        newItemTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        newItemTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15).isActive = true
        newItemTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        newItemTextField.trailingAnchor.constraint(equalTo: addItemButton.leadingAnchor, constant: 15).isActive = true
        
        addItemButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        addItemButton.leadingAnchor.constraint(equalTo: newItemTextField.trailingAnchor, constant: 15).isActive = true
        addItemButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }

    @objc func addItem(_ : UIButton) {
        
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = shoppingList[indexPath.row]
        item.completed.toggle()
        let cell = shoppingListTableView.cellForRow(at: indexPath) as! ShoppingListCell
        cell.updateStatusImage(item: item)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            let animation = UITableView.RowAnimation.automatic
            shoppingListTableView.beginUpdates()
            shoppingListTableView.deleteRows(at: [indexPath], with: animation)
            shoppingListTableView.endUpdates()
        }
    }
}

extension ShoppingListViewController {
    struct Cell {
        static let identifier = "ItemCell"
    }
    
    func getList() {
        let item0 = ListItem("Jam")
        let item1 = ListItem("Black Beans")
        let item2 = ListItem("Bacon", completed: true)
        shoppingList.append(item0)
        shoppingList.append(item1)
        shoppingList.append(item2)
    }
}
