//
//  ViewController.swift
//  Email Login
//
//  Created by Sam Catalfo on 8/19/17.
//  Copyright © 2017 CatalfoGames. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class SignInVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {


    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        //let splashView = LDSplashView(initWithSplashIcon: LDSplashIcon(initWithImage: #imageLiteral(resourceName: "testAppIcon")), backgroundColor: UIColor.blue, animationType: LDSplashView.LDSplashAnimationType.Zoom)!
        
        //splashView.animationDuration = 3.0 //Set the animation duration (Default: 1s)
        
        //self.view.addSubview(splashView) //Add the splash view to your current view
        
        //splashView.startAnimation() //Call this method to start the splash animation
        
    }

    @IBAction func onSignInTapped(_ sender: UIButton!) {
        guard let email = emailTF.text,
        email != "",
        let password = passwordTF.text,
        password != ""
            else{
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else{
            AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
            return
        }
        guard let user = user else {
            return
        }
        print(user.email ?? "MISSING EMAIL")
        print(user.displayName ?? "MISSING DISPLAY NAME")
        print(user.uid)
        self.performSegue(withIdentifier: "signInSegue", sender: nil)
        }
        
    
    

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil
        {
            self.performSegue(withIdentifier: "signInSegue", sender: nil)
        }
        else{
            return
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential){(user, error) in
            self.performSegue(withIdentifier: "signInSegue", sender: nil)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


}
