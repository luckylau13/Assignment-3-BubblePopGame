//
//  CreateSLViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit

class CreateSLViewController: UIViewController {

    @IBOutlet weak var shoppingListTextfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.applyButtonDesign()
    }


}
