//
//  AllThree.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 10/22/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase

//var outroArray = [String]()

class AllThree: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //@IBOutlet var videoPreviewLayer: UIView!
    @IBOutlet var footageLabel: UILabel!
    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var thumbnailView2: UIImageView!
    @IBOutlet var thumbnailView3: UIImageView!
    static var player: AVQueuePlayer!
    static var avpController = AVPlayerViewController()
    static var player2: AVQueuePlayer!
    static var avpController2 = AVPlayerViewController()
    static var player3: AVQueuePlayer!
    static var avpController3 = AVPlayerViewController()
    let slideAnimator = SlideAnimator()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var nextElement: String = ""
    /*
    @IBAction func makeVideo(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]//, kUTTypeImage as String]
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: {})
                //photoCounter = photoCounter+1
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("AllThree loaded")
        //Commentary.player = AVQueuePlayer(url: URL(string: hifiEventArray.last!)!)
        var items:[AVPlayerItem] = []
        for str in hifiEventArray{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player = AVQueuePlayer(items: items)
        AllThree.avpController = AVPlayerViewController()
        AllThree.avpController.player = AllThree.player
        if (!hifiEventArray.isEmpty){
            thumbnailView.image = AVAsset(url: URL(string: hifiEventArray.first!)!).videoThumbnail!
        }
        
        var items2:[AVPlayerItem] = []
        for str in commentaryArray{
            items2.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player2 = AVQueuePlayer(items: items2)
        AllThree.avpController2 = AVPlayerViewController()
        AllThree.avpController2.player = AllThree.player2
        if (!commentaryArray.isEmpty){
            thumbnailView2.image = AVAsset(url: URL(string: commentaryArray.first!)!).videoThumbnail!
        }
        
        var items3:[AVPlayerItem] = []
        for str in outroArray{
            items3.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player3 = AVQueuePlayer(items: items3)
        AllThree.avpController3 = AVPlayerViewController()
        AllThree.avpController3.player = AllThree.player3
        if (!outroArray.isEmpty){
            thumbnailView3.image = AVAsset(url: URL(string: outroArray.first!)!).videoThumbnail!
        }
        //Commentary.avpController.view.frame = videoPreviewLayer.frame
        //self.addChildViewController(Commentary.avpController)
        //self.view.addSubview(Commentary.avpController.view)
        //self.avpController.contentOverlayView?.addSubview(editButton)
        footageLabel.text = "Main Footage (\(commentaryArray.count))"
        
    }
    static func updatePlayer(){
        //Commentary.player = AVQueuePlayer(url: URL(string: hifiEventArray.last!)!)
        var items:[AVPlayerItem] = []
        for str in hifiEventArray{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player = AVQueuePlayer(items: items)
        AllThree.avpController.player = self.player
        
        var items2:[AVPlayerItem] = []
        for str in commentaryArray{
            items2.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player2 = AVQueuePlayer(items: items2)
        AllThree.avpController2.player = self.player2
        
        var items3:[AVPlayerItem] = []
        for str in outroArray{
            items3.append(AVPlayerItem(url: URL(string: str)!))
        }
        AllThree.player3 = AVQueuePlayer(items: items3)
        AllThree.avpController3.player = self.player3
        /*
         DispatchQueue.main.async {
         Commentary.avpController.view.frame = CGRect(x: 0, y: 60, width: 377, height: 199)
         }
         */
        
    }
    
    @IBAction func deleteVideo(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Delete Video", message: "Are you sure that you want to delete this video?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        /*
         alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
         */
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
            
            // do something like...
            if (hifiEventArray.count > 0){
                hifiEventArray.popLast()
                self.postAlert("Last video deleted successfully", message: ":)")
                AllThree.updatePlayer()
                if (!hifiEventArray.isEmpty){
                    self.thumbnailView.image = AVAsset(url: URL(string: hifiEventArray.first!)!).videoThumbnail!
                }
                else{
                    self.thumbnailView.image = UIImage(named: "noImageAvailable")
                }
            }
            else{
                //hifiEventArray.popLast()
                self.postAlert("No videos left here", message: "You should add some more videos!")
                //Commentary.updatePlayer()
                //self.performSegue(withIdentifier: "addIntroVideo", sender: nil)
            }
        }))
        // show the alert
        self.present(alert, animated: true) {
            
        }
    }
    @IBAction func deleteVideo2(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Delete Video", message: "Are you sure that you want to delete this video?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        /*
         alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
         */
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
            
            // do something like...
            if (commentaryArray.count > 0){
                commentaryArray.popLast()
                self.postAlert("Last video deleted successfully", message: ":)")
                AllThree.updatePlayer()
                if (!commentaryArray.isEmpty){
                    self.thumbnailView2.image = AVAsset(url: URL(string: commentaryArray.first!)!).videoThumbnail!
                }
                else{
                    self.thumbnailView2.image = UIImage(named: "noImageAvailable")
                }
            }
            else{
                //hifiEventArray.popLast()
                self.postAlert("No videos left here", message: "You should add some more videos!")
                //Commentary.updatePlayer()
                //self.performSegue(withIdentifier: "addIntroVideo", sender: nil)
            }
        }))
        // show the alert
        self.present(alert, animated: true) {
            
        }
        
    }
    @IBAction func deleteVideo3(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Delete Video", message: "Are you sure that you want to delete this video?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        /*
         alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
         */
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
            
            // do something like...
            if (outroArray.count > 0){
                outroArray.popLast()
                self.postAlert("Last video deleted successfully", message: ":)")
                AllThree.updatePlayer()
                if (!outroArray.isEmpty){
                    self.thumbnailView3.image = AVAsset(url: URL(string: outroArray.first!)!).videoThumbnail!
                }
                else{
                    self.thumbnailView3.image = UIImage(named: "noImageAvailable")
                }
            }
            else{
                //hifiEventArray.popLast()
                self.postAlert("No videos left here", message: "You should add some more videos!")
                //Commentary.updatePlayer()
                //self.performSegue(withIdentifier: "addIntroVideo", sender: nil)
            }
        }))
        // show the alert
        self.present(alert, animated: true) {
            
        }
        
    }
    /*
    @IBAction func chooseVideo(_ sender: Any) {
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        imagePicker.mediaTypes = ["public.movie"]//"public.image"
        present(imagePicker, animated: true, completion: nil)
    }
    */
    
    @IBAction func playEvent(_ sender: Any) {
        //thumbnailView.image = AVAsset(url: URL(string: hifiEventArray.last!)!).videoThumbnail!
        self.present(AllThree.avpController, animated: true){
            AllThree.avpController.player?.play()
        }
    }
    
    @IBAction func playEvent2(_ sender: Any) {
        //thumbnailView.image = AVAsset(url: URL(string: hifiEventArray.last!)!).videoThumbnail!
        self.present(AllThree.avpController2, animated: true){
            AllThree.avpController2.player?.play()
        }
    }
    @IBAction func playEvent3(_ sender: Any) {
        //thumbnailView.image = AVAsset(url: URL(string: hifiEventArray.last!)!).videoThumbnail!
        self.present(AllThree.avpController3, animated: true){
            AllThree.avpController3.player?.play()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepared")
        let destination = segue.destination
        destination.transitioningDelegate = slideAnimator
    }
    
    @IBAction func pressedDiscard(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Discard Changes", message: "Are you sure that you want to discard these changes?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true) {
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
                
                // do something like...
                self.performSegue(withIdentifier: "exitAllThree", sender: nil)
                hifiEventArray.removeAll()
                commentaryArray.removeAll()
                outroArray.removeAll()
            }))
        }
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let countStr = String(randomString(length: 10))
        let saveFileName = "/test" + countStr + ".mp4"
        print("Got a video")
        
        if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(AllThree.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = try? Data(contentsOf: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
            try! videoData?.write(to: dataPath, options: [])
            print("Saved to " + dataPath.absoluteString)
            nextElement = dataPath.absoluteString
        }
        
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an video
            /*
             if (self.imagePicker.sourceType == .photoLibrary){
             commentaryArray.append(self.nextElement)
             self.postAlert("test",message: "video saved in photo library sucessfully")
             }
             */
            outroArray.append(self.nextElement)
            self.performSegue(withIdentifier: "finishedOutro", sender: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    @objc func videoWasSavedSuccessfully(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                // What you want to happen
            })
        }
    }
    */
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    /*
     func getArray() -> [String]{
     return self.interviewArray
     }
     */
}

