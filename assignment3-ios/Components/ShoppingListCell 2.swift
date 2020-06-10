//
//  ShoppingListCell.swift
//  TestTableView
//
//  Created by Vong Beng on 3/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    var itemTitleLabel : UILabel = UILabel()
    var itemStatusImageView : UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(itemTitleLabel)
        addSubview(itemStatusImageView)
        
        configureTitle()
        configureStatus()
        
        setTitleConstraints()
        setStatusConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(item: ListItem) {
        itemTitleLabel.text = item.title
        updateStatusImage(item: item)
    }
    
    func updateStatusImage(item: ListItem) {
        itemStatusImageView.image = item.statusImage
        if item.completed {
            itemStatusImageView.tintColor = .systemGreen
        } else {
            itemStatusImageView.tintColor = .lightGray
        }
    }
    
    func configureTitle() {
        itemTitleLabel.numberOfLines = 0
        itemTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureStatus() {
        
    }
    
    func setStatusConstraints() {
        itemStatusImageView.translatesAutoresizingMaskIntoConstraints = false
        itemStatusImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemStatusImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        itemStatusImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        itemStatusImageView.widthAnchor.constraint(equalTo: itemStatusImageView.heightAnchor).isActive = true
    }
    
    func setTitleConstraints() {
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        itemTitleLabel.trailingAnchor.constraint(equalTo: itemStatusImageView.leadingAnchor, constant: -15).isActive = true
    }
}
