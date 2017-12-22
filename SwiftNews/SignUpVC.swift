//
//  SignUpVC.swift
//  Email Login
//
//  Created by Sam Catalfo on 8/19/17.
//  Copyright © 2017 CatalfoGames. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!

    @IBAction func onSignUpTapped(_ sender: Any) {
        
        guard let username = usernameTF.text,
        username != "",
        let email = emailTF.text,
        email != "",
        let password = passwordTF.text,
        password != "",
        let confirmPassword = confirmPasswordTF.text,
        confirmPassword != ""
            else{
                
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields")
                return
            }
        if(password == confirmPassword)
        {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
                guard let user = user else{
                    return
                }
                print(user.email ?? "MISSSING EMAIL")
                print(user.uid)
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges(completion: { (error) in
                    guard error == nil else {
                        AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                        return
                    }
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                })
                
            }
        }
        else{
            AlertController.showAlert(self, title: "The passwords don't match", message: "Make sure confirm password and password are the same")
        }

    }

}
