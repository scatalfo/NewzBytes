//
//  LaunchAnimation.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 12/9/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit

class LaunchAnimation: UIViewController {

    @IBOutlet var layer: SpringImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        layer.animation = "squeezeDown"
        layer.animate()
        layer.delay = 1
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(1)
        mainQueue.asyncAfter(deadline: deadline){
            print("animation finished")
            self.performSegue(withIdentifier: "launchAnimation", sender: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
