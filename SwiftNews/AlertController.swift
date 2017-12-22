//
//  AlertController.swift
//  Email Login
//
//  Created by Sam Catalfo on 8/19/17.
//  Copyright © 2017 CatalfoGames. All rights reserved.
//

import UIKit
class AlertController {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
