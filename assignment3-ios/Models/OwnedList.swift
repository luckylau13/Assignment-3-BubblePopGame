//
//  OwnedList.swift
//  assignment3-ios
//
//  Created by Vong Beng on 11/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

class OwnedList {
    var id : String = ""
    var listName : String = ""
    
    init(id: String = "-----", name: String = "Untitled") {
        self.id = id
        self.listName = name
    }
}
