//
//  ListItem.swift
//  TestTableView
//
//  Created by Vong Beng on 3/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit

class ListItem {
    var id : String = ""
    var title : String = "No Name"
    var completed : Bool = false
    var statusImage : UIImage {
        if completed {
            return UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        } else {
            return UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        }
    }
    
    init(_ title: String, completed: Bool = false) {
        self.title = title
        self.completed = completed
    }
    
    init(_ id : String, from dictionary: [String : Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? "Untitled Item"
        self.completed = dictionary["completed"] as? Bool ?? false
    }
    
    var dictionary : [String : Any] {
        return [
            "title" : title,
            "completed" : completed
        ]
    }
}
