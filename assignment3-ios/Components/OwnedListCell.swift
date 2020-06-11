//
//  OwnedListCell.swift
//  assignment3-ios
//
//  Created by Vong Beng on 11/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import UIKit

class OwnedListCell: UITableViewCell {

//    var ownedList = OwnedList()
    
    var listNameLabel : UILabel = UILabel()
    var listIDLabel : UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        addSubview(listNameLabel)
        addSubview(listIDLabel)
        
        configureLabels()
        
        setListNameConstraints()
        setListIDConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(list: OwnedList) {
        listNameLabel.text = list.listName
        listIDLabel.text = "Code: \(list.id)"
    }
    
    func configureLabels() {
        listNameLabel.numberOfLines = 0
        listIDLabel.numberOfLines = 0
        
        listNameLabel.adjustsFontSizeToFitWidth = true
        listIDLabel.adjustsFontSizeToFitWidth = true
        
        listNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    func setListNameConstraints() {
        listNameLabel.translatesAutoresizingMaskIntoConstraints = false
        listNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        listNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        listNameLabel.trailingAnchor.constraint(equalTo: listIDLabel.leadingAnchor, constant: -15).isActive = true
        listNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func setListIDConstraints() {
        listIDLabel.translatesAutoresizingMaskIntoConstraints = false
        
        listIDLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        listIDLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        listIDLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        listIDLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
