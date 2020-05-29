//
//  JoinSLViewController.swift
//  assignment3-ios
//
//  Created by Ayden Heng on 29/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import UIKit

class JoinSLViewController: UIViewController {

    @IBOutlet weak var joinSLTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButton.applyButtonDesign()
    }


}
