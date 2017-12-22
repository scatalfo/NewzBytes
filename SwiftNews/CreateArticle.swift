//
//  CreateArticle.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 9/1/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase

var headlineArray = [String]()

class CreateArticle: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var subtextField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var imageTake: UIImageView?
    let slideAnimator = SlideAnimator()
    
    var nextElement: String = ""
    //let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func makeVideo(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
                //photoCounter = photoCounter+1
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func save(_ sender: AnyObject) {
        //UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, nil, nil)
        //let imageData = UIImagePNGRepresentation(imageTake.image!)!
        let imageData = UIImageJPEGRepresentation((imageTake?.image)!, 0.1) as! Data
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(randomString(length: 10)+".png")
        try! imageData.write(to: imageURL)
        
        //let newImage = UIImage(contentsOfFile: imageURL.path)!
        nextElement = imageURL.absoluteString
        print(nextElement)
        headlineArray.append(nextElement)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func chooseVideo(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
        
            imagePicker.mediaTypes = ["public.image"]//"public.image"
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            postAlert("Photo library soruce type not available", message: "IDK")
        }
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageTake?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        /*
        if (imagePicker.sourceType == .photoLibrary){
            print("appended to array")
            self.eventArray.append(self.nextElement)
        }
         */
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    func videoWasSavedSuccessfully(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                // What you want to happen
            })
        }
    }
    
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
    @IBAction func submitArticle(_ sender: Any) {
        var childautoID = "not yet declared"
        let storage = Storage.storage()
        var storageRef = storage.reference();
        
        //upload the headline and store URL as 'headlineDownloadURL'
        // File located on disk
        let headlineLocalFile = URL(string: headlineArray[headlineArray.count-1])!
        
        // Create a reference to the file you want to upload
        let headlineRef = storageRef.child("images/" + randomString(length: 10) + ".jpg")
        
        // Upload the file to the ref path (/images)
        var headlineDownloadURL = "test2"
        let headlineUploadTask = headlineRef.putFile(from: headlineLocalFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                headlineDownloadURL = metadata!.downloadURL()!.absoluteString
                print(headlineDownloadURL)
                Database.database().reference().child("articles/" + childautoID + "/urlToImage").setValue(headlineDownloadURL)
            }
        }
        
        //upload the event and store URL as eventDownloadURL
        // File located on disk
        
        //COMMENT OUT THE FOLLOWLING LINE!!!!!!!:
        //let selfInterviewArray = [String]()
        let eventLocalFile = URL(string: eventArray[eventArray.count-1])
        
        // Create a reference to the file you want to upload
        let eventRef = storageRef.child("videos/" + randomString(length: 10) + ".mp4")
        
        // Upload the file to the ref path (/videos)
        
        var eventDownloadURL = "test"
        let eventUploadTask = eventRef.putFile(from: eventLocalFile!, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                eventDownloadURL = metadata!.downloadURL()!.absoluteString
                print(eventDownloadURL)
                Database.database().reference().child("articles/" + childautoID + "/video").setValue(eventDownloadURL)
            }
        }
        
        //upload interview
        
        let interviewLocalFile = URL(string: interviewArray[interviewArray.count-1])
        
        // Create a reference to the file you want to upload
        let interviewRef = storageRef.child("videos/" + randomString(length: 10) + ".mp4")
        
        // Upload the file to the ref path (/videos)
        
        var interviewDownloadURL = "test"
        let interviewUploadTask = interviewRef.putFile(from: interviewLocalFile!, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                interviewDownloadURL = metadata!.downloadURL()!.absoluteString
                print(interviewDownloadURL)
                Database.database().reference().child("articles/" + childautoID + "/interview").setValue(interviewDownloadURL)
            }
        }

        
        //upload the URLs to the database
        //let postInfo = ["Description": txtPostDescription.text!, "ImageUrl": imgUrl, "Likes": 0]
        
        let postInfo = ["video": eventDownloadURL, "interview": interviewDownloadURL, "urlToImage": headlineDownloadURL, "title": titleField.text!, "description": subtextField.text!, "author": publicUsername]
        
        let reference  = Database.database().reference().child("articles").childByAutoId()
        
        reference.setValue(postInfo)
        childautoID = reference.key
        print(childautoID)
        
    }
    /*
    func mergeVideos(selfInterview: String, event: String) -> String {
        //code
        var totalTime: CMTime = CMTimeMake(0, 0)
        var atTimeM: CMTime = CMTimeMake(0, 0)
        let mixComposition = AVMutableComposition()
        let arrayVideos = [AVAsset.init(url: URL(string: selfInterview)!), AVAsset.init(url: URL(string: event)!)]
        
        for videoAsset in arrayVideos{
            let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do{
                if videoAsset == arrayVideos.first{
                    atTimeM = kCMTimeZero
                }
                else{
                    atTimeM = totalTime
                }
                try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0], at: atTimeM)} catch let error as NSError{
                    print("error: \(error)")
            }
            totalTime = totalTime + videoAsset.duration
        }
        
        let completeMovie = "/test" + randomString(length: 10) + ".mp4"
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSURL = NSURL(fileURLWithPath: paths[0])
        
        let completeMovieUrl = documentsDirectory
        var exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset1920x1080)!
        exporter.outputURL = completeMovieUrl as URL
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously {
            switch exporter.status{
            case AVAssetExportSessionStatus.failed:
                print("failed \(exporter.error)")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(exporter.error)")
            default:
                print("Composition exported sucessfully.")
            }
            
        }
        return exporter.outputURL!.absoluteString
    }
    */
}
extension String{
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        print("DOUBLEALPH FLAG \(nsSt.appendingPathComponent(path))")
        return nsSt.appendingPathComponent(path)
    }
}

    
    

