//
//  Headline.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 9/13/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase

var headline = ""
var subtext = ""

class Headline: UIViewController, UINavigationControllerDelegate{
    let slideAnimator = SlideAnimator()
    
    
  
    @IBOutlet weak var theHeadline: UITextField!
    
    @IBOutlet var theSubtext: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Headline.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = slideAnimator
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func pressedNext(_ sender: Any) {
        headline = theHeadline.text!
        subtext = theSubtext.text
    }
    
}
