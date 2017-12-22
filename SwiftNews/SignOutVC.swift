//
//  SignOutVC.swift
//  Email Login
//
//  Created by Sam Catalfo on 8/19/17.
//  Copyright © 2017 CatalfoGames. All rights reserved.
//

import UIKit
import Firebase

class SignOutVC: UIViewController {

    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "goToMain", sender: nil)
    }
        

}
