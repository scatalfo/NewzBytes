//
//  SubmitArticle.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 10/28/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase
import CoreLocation

class SubmitArticle: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var articleTitle: KMPlaceholderTextView!
    
    @IBOutlet var articleText: KMPlaceholderTextView!
    let slideAnimator = SlideAnimator()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var label = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var logo = UIImageView()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            let theHeight = view.frame.size.height //grabs the height of your view
            let theWidth = view.frame.size.width
            label.frame = CGRect(x: 0, y: theWidth-42 , width: theHeight*0.75, height: 42)
            label2.frame = CGRect(x: 0, y: 0 , width: theHeight, height: 42)
            label3.frame = CGRect(x: 0, y: theWidth-63, width: theHeight * 0.42, height: 21)
            logo.frame = CGRect(x: theHeight-42, y: theWidth - 42, width: 42, height: 42)
        } else {
            print("Portrait")
            let theHeight = view.frame.size.height //grabs the height of your view
            let theWidth = view.frame.size.width
            label.frame = CGRect(x: 0, y: theHeight - 84 , width: theWidth*0.75, height: 84)
            label2.frame = CGRect(x: 0, y: 0 , width: theWidth, height: 84)
            label3.frame = CGRect(x: 0, y: theHeight - 126, width: theWidth * 0.42, height: 42)
            logo.frame = CGRect(x: theWidth-84, y: theHeight - 84, width: 84, height: 84)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theHeight = view.frame.size.height //grabs the height of your view
        let theWidth = view.frame.size.width
        
        label = UILabel()
        //let screenSize: CGRect = UIScreen.main.bounds
        //label.text = self.articles?[indexPath.item].headline
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = false
        
        label.frame = CGRect(x: 0, y: theHeight - 84 , width: theWidth*0.75, height: 84)
        //label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        //label.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        //playerViewController.contentOverlayView?.addSubview(self.label)
        label2 = UILabel()
        //let screenSize: CGRect = UIScreen.main.bounds
        //label2.text = self.articles?[indexPath.item].headline
        label2.textAlignment = NSTextAlignment.center
        label2.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        label2.textColor = UIColor.white
        label2.font = UIFont.boldSystemFont(ofSize: 25)
        label2.adjustsFontSizeToFitWidth = false
        
        label2.frame = CGRect(x: 0, y: 0 , width: theWidth, height: 84)
        //label2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        //label2.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        //playerViewController.contentOverlayView?.addSubview(self.label2)
        
        label3 = UILabel()
        label3.textAlignment = NSTextAlignment.center
        label3.backgroundColor = UIColor.red
        label3.textColor = UIColor.white
        label3.font = UIFont.boldSystemFont(ofSize: 14)
        label3.frame = CGRect(x: 0, y: theHeight - 126, width: theWidth * 0.42, height: 42)
        
        logo = UIImageView()
        logo.frame = CGRect(x: theWidth-84, y: theHeight - 84, width: 84, height: 84)
        logo.image = #imageLiteral(resourceName: "testAppIcon")
        // Do any additional setup after loading the view.
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubmitArticle.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    @IBAction func previewArticle(_ sender: Any) {
        let avpController = AVPlayerViewController()
        var items: [AVPlayerItem] = []
        
        for str in hifiEventArray{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        
        for str in commentaryArray{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        
        for str in outroArray{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        
        let player = AVQueuePlayer(items: items)
        avpController.player = player
        
        let articleLocation = CLLocation(latitude: currentLocation?.latitude ?? 0, longitude: currentLocation?.longitude ?? 0)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(articleLocation) { (placemarkArray, error) in
            var city = placemarkArray!.first!.locality!
            print("city: \(city)")
            if (error != nil){
                print("geolocator error: \(error)")
            }
            self.label.text = "\(self.articleTitle.text ?? "")\n  INSERT DATE HERE | \(city) | by   \(publicUsername)"
            self.label.numberOfLines = 0
            self.label2.text = "\(String(describing: publicUsername))'s Story"
            self.label3.text = "CATEGORY"
            /*
             label.textAlignment = NSTextAlignment.center
             label.backgroundColor = UIColor.white
             label.textColor = UIColor.black
             label.font = UIFont.systemFont(ofSize: 15)
             label.adjustsFontSizeToFitWidth = false
             label.frame = CGRect(x: 0, y: screenSize.width - 0.5*screenSize.height*0.1, width: screenSize.height, height: screenSize.width * 0.1)
             //label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
             label.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
             */
            
            
            self.present(avpController, animated: true) {
                avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                avpController.contentOverlayView?.addSubview(self.label)
                avpController.contentOverlayView?.addSubview(self.label2)
                avpController.contentOverlayView?.addSubview(self.label3)
                avpController.contentOverlayView?.addSubview(self.logo)
                avpController.player?.play()
            }
        }
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
        
        let imageData = UIImageJPEGRepresentation(AVAsset(url: URL(string:commentaryArray.first!)!).videoThumbnail!, 0.1)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(randomString(length: 10)+".jpg")
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
        for str in commentaryArray{
            let eventLocalFile = URL(string: str)
            
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
                    Database.database().reference().child("articles/" + childautoID + "/video/" + self.randomString(length: 10)).setValue(eventDownloadURL)
                    //eventArray.removeAll()
                }
            }
        }
        commentaryArray.removeAll()
        //upload self interview
        for str in hifiEventArray{
            let interviewLocalFile = URL(string: str)
            
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
                    Database.database().reference().child("articles/" + childautoID + "/interview/" + self.randomString(length: 10)).setValue(interviewDownloadURL)
                    //interviewArray.removeAll()
                }
            }
        }
        hifiEventArray.removeAll()
        //upload other interviews
        for str in outroArray{
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
        outroArray.removeAll()
        
        //upload the text
        //let postInfo = ["Description": txtPostDescription.text!, "ImageUrl": imgUrl, "Likes": 0]
        //let postInfo = ["title": headline, "description": subtext, "author": publicUsername]
        
        
        reference.child("title").setValue(articleTitle.text!)
        reference.child("description").setValue(articleText.text!)
        reference.child("author").setValue(publicUsername)
        reference.child("long").setValue(currentLocation?.longitude)
        reference.child("lat").setValue(currentLocation?.latitude)
        
        print(childautoID)
        
        self.performSegue(withIdentifier: "justSubmittedArticle", sender: nil)
        
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
