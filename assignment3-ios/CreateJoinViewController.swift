//
//  CreateJoinViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit

class CreateJoinViewController: UIViewController {
    var db:Firestore!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var createSLButton: UIButton!
    @IBOutlet weak var joinSLButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        createSLButton.applyButtonDesign()
        joinSLButton.applyButtonDesign()
        
    }


}

extension UIButton {
    func applyButtonDesign() {
        self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.layer.cornerRadius = 25.0
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
