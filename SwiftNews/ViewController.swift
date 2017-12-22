//
//  ViewController.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 8/19/17.
//  Copyright (c) 2017 Catalfo Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let V1 = self.storyboard?.instantiateViewController(withIdentifier: "V1") as! UIViewController
        self.addChildViewController(V1)
        self.scrollView.addSubview(V1.view)
        V1.didMove(toParentViewController: self)
        V1.view.frame = scrollView.bounds
        
        /*
        let V2 = self.storyboard?.instantiateViewController(withIdentifier: "CE") as! UIViewController
        self.addChildViewController(V2)
        self.scrollView.addSubview(V2.view)
        V2.didMove(toParentViewController: self)
        V2.view.frame = scrollView.bounds
        
        var V2Frame : CGRect = V2.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        */
 
        let V4 = self.storyboard?.instantiateViewController(withIdentifier: "ArticleMaker") as! UIViewController
        self.addChildViewController(V4)
        self.scrollView.addSubview(V4.view)
        V4.didMove(toParentViewController: self)
        V4.view.frame = scrollView.bounds
        
        var V4Frame: CGRect = V4.view.frame
        V4Frame.origin.x = self.view.frame.width
        V4.view.frame = V4Frame
        /*
        let layer1 = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 64))
        
        let gradient1 = CAGradientLayer()
        gradient1.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        gradient1.colors = [
            UIColor(red:0.02, green:0.36, blue:0.48, alpha:1).cgColor,
            UIColor.black.cgColor
        ]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.5, y: -0.29)
        gradient1.endPoint = CGPoint(x: 0.5, y: 1)
        layer1.layer.addSublayer(gradient1)
        V4.view.addSubview(layer1)
        
        let layer2 = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 1080))
        layer2.backgroundColor = UIColor.white
        layer2.addSubview(UIImageView(image: UIImage(named: "backArrow")))
        V4.view.addSubview(layer2)
        */
        let V3 = self.storyboard?.instantiateViewController(withIdentifier: "V3") as! UIViewController
        self.addChildViewController(V3)
        self.scrollView.addSubview(V3.view)
        V3.didMove(toParentViewController: self)
        V3.view.frame = scrollView.bounds
        
        var V3Frame : CGRect = V3.view.frame
        V3Frame.origin.x = 2*self.view.frame.width
        V3.view.frame = V3Frame
        
        self.scrollView.contentSize = CGSize(width: (self.view.frame.width)*3, height: self.view.frame.height)
        self.scrollView.contentOffset = CGPoint(x: 0*(self.view.frame.width), y: 0*self.view.frame.height)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

