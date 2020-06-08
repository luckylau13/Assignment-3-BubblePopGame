//
//  ViewController.swift
//  assignment3-ios
//
//  Created by Lucky Lau on 22/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var joinShoppingListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.applyButtonDesign()
        joinShoppingListButton.applyButtonDesign()
        // Do any additional setup after loading the view.
    }


}

