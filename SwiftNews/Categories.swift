//
//  Categories.swift
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
import CoreLocation

class Categories: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    let slideAnimator = SlideAnimator()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            currentLocation = location.coordinate
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
    
    @IBAction func submitArticle(_ sender: Any) {
        let reference  = Database.database().reference().child("articles").childByAutoId()
        let childautoID = reference.key
        let storage = Storage.storage()
        var storageRef = storage.reference();
        
        reference.child("uID").setValue(Auth.auth().currentUser!.uid)
        
        //upload the headline and store URL as 'headlineDownloadURL'
        // File located on disk
        //let headlineLocalFile = URL(string: headlineArray.last!)
        
        let imageData = UIImageJPEGRepresentation(AVAsset(url: URL(string:eventArray.last!)!).videoThumbnail!, 0.1)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(randomString(length: 10)+".png")
        try! imageData?.write(to: imageURL) //NOTE: Make sure there is a video event or this will crash
        
        let thumbnailLocalFile = imageURL
        
        // Create a reference to the file you want to upload
        let headlineRef = storageRef.child("images/" + Auth.auth().currentUser!.uid + "/" + randomString(length: 10) + ".jpg")
        
        // Upload the file to the ref path (/images)
        var headlineDownloadURL = "test2"
        let headlineUploadTask = headlineRef.putFile(from: thumbnailLocalFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("error uploading thumbnail" + error.localizedDescription)
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
        let eventLocalFile = URL(string: eventArray.last!)
        
        // Create a reference to the file you want to upload
        let eventRef = storageRef.child("videos/" + Auth.auth().currentUser!.uid + "/" + randomString(length: 10) + ".mp4")
        
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
                eventArray.removeAll()
            }
        }
        
        //upload self interview
        
        let interviewLocalFile = URL(string: interviewArray.last!)
        
        // Create a reference to the file you want to upload
        let interviewRef = storageRef.child("videos/" + Auth.auth().currentUser!.uid + "/" + randomString(length: 10) + ".mp4")
        
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
                interviewArray.removeAll()
            }
        }
        
        //upload other interviews
        for str in interviewOthersArray{
            let interviewLocalFile = URL(string: str)
            
            // Create a reference to the file you want to upload
            let interviewRef = storageRef.child("videos/" + Auth.auth().currentUser!.uid + "/" + randomString(length: 10) + ".mp4")
            
            // Upload the file to the ref path (/videos)
            
            var interviewDownloadURL = "test"
            let interviewUploadTask = interviewRef.putFile(from: interviewLocalFile!, metadata: nil) { metadata, error in
                if let error = error {
                    print("error uploading an interview, \(error.localizedDescription)")
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    interviewDownloadURL = metadata!.downloadURL()!.absoluteString
                    print(interviewDownloadURL)
                    Database.database().reference().child("articles/" + childautoID + "/interviewOthers/" + self.randomString(length: 10)).setValue(interviewDownloadURL)
                    //interviewArray.remove(at: (interviewArray.index(of: interviewDownloadURL)!)) //WOOPS WRONG ARRAY AHAHAHHAHAH
                }
            }
        }
        interviewOthersArray.removeAll()
        
        //upload the text
        //let postInfo = ["Description": txtPostDescription.text!, "ImageUrl": imgUrl, "Likes": 0]
        //let postInfo = ["title": headline, "description": subtext, "author": publicUsername]
        
        
        reference.child("title").setValue(headline)
        reference.child("description").setValue(subtext)
        reference.child("author").setValue(publicUsername)
        reference.child("long").setValue(currentLocation?.longitude)
        reference.child("lat").setValue(currentLocation?.latitude)
        
        print(childautoID)
        
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
/*
extension AVAsset{
    var videoThumbnail:UIImage?{
        
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            
            print("Video Thumbnail genertated successfuly")
            
            return thumbNail
            
        } catch {
            
            print("error getting thumbnail video",error.localizedDescription)
            return nil
            
            
        }
        
    }
}
 */
