//
//  View1.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 8/19/17.
//  Copyright (c) 2017 Catalfo Productions. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AVKit
import AVFoundation

var publicUsername = ""

class View1: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableview: UITableView!
    @IBOutlet var newsReaderTitle: UINavigationItem!
    var label = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var logo = UIImageView()
    let playerViewController = AVPlayerViewController()
    
    var articles: [Article] = []
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Auth.auth().currentUser != nil){
            fetchArticles()
            
            
            guard let username = Auth.auth().currentUser?.displayName else{
                return
            }
            publicUsername = username
            newsReaderTitle.title = "News for \(username)"
            
            // Do any additional setup after loading the view.
            
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
        }
        else{
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
    }
    
    func getUsername() -> (String){
        return (Auth.auth().currentUser?.displayName)!
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do{
            print(Auth.auth().currentUser?.displayName)
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance().signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        }catch{
            print(error)
        }
    }
    
    func fetchArticles(){

        
        
        /*
        let urlRequest = URLRequest(url: URL(string: "https://swiftnews-e7222.firebaseio.com/.json?")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["video"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let error {
                print(error)
            }
            
            
        }
 
        task.resume()
        
        */
        
        let ref = Database.database().reference()
        ref.child("articles").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let article = Article()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                if (snap.key == "interviewOthers"){
                    article.interviewOthers = []
                    for nextChild in snap.children{
                        let nextSnap = nextChild as! DataSnapshot
                        print("interview other child: \(nextSnap.value as? String)")
                        article.interviewOthers?.append(nextSnap.value as! String)
                    }
                }
                if (snap.key == "author"){
                    article.author = snap.value as? String
                }
                if (snap.key == "description"){
                    article.desc = snap.value as? String
                }
                if (snap.key == "title"){
                    article.headline = snap.value as? String
                }
                if (snap.key == "video"){
                    article.url = []
                    for nextChild in snap.children{
                        let nextSnap = nextChild as! DataSnapshot
                        article.url?.append(nextSnap.value as! String)
                    }
                    //article.url = snap.value as? String
                }
                if (snap.key == "urlToImage"){
                    article.imageUrl = snap.value as? String
                }
                if (snap.key == "interview"){
                    article.interviewUrl = []
                    for nextChild in snap.children{
                        let nextSnap = nextChild as! DataSnapshot
                        article.interviewUrl?.append(nextSnap.value as! String)
                    }
                    //article.interviewUrl = snap.value as? String
                }
                if (snap.key == "lat"){
                    article.lat = snap.value as? Double
                }
                if (snap.key == "long"){
                    article.long = snap.value as? Double
                }
            }
            article.interviewOthers=article.interviewOthers ?? [""]
            article.author=article.author ?? ""
            article.desc=article.desc ?? ""
            article.headline=article.headline ?? ""
            article.url=article.url ?? [""]
            article.imageUrl=article.imageUrl ?? ""
            article.interviewUrl=article.interviewUrl ?? [""]
            self.articles.append(article)
            print(article.interviewOthers)
            //Reload your tableView
            self.tableview.reloadData()
            /*
            if let valueDictionary = snapshot.value as? [AnyHashable:String]
            {
                let author = valueDictionary["author"]
                let desc = valueDictionary["description"]
                let headline = valueDictionary["title"]
                let url = valueDictionary["video"]
                let imageUrl = valueDictionary["urlToImage"]
                let interviewUrl = valueDictionary["interview"]
                
                
                article.author = author
                article.desc = desc
                article.headline = headline
                article.url = url
                article.imageUrl = imageUrl
                article.interviewUrl = interviewUrl
                
                
                self.articles?.append(article)
                //Reload your tableView
                self.tableview.reloadData()
            }
            */
        })
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell)
        
        cell?.title.text = self.articles[indexPath.item].headline
        cell?.desc.text = self.articles[indexPath.item].desc
        cell?.author.text = self.articles[indexPath.item].author
        
        cell?.imgView.downloadImage(from: (self.articles[indexPath.item].imageUrl!))
        
        cell?.longitude.text = String(format:"%f", self.articles[indexPath.item].long ?? 0)
        cell?.latitude.text = String(format:"%f", self.articles[indexPath.item].lat ?? 0)
        
        return cell ?? UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        print("tapped")
        /*
        class OurVideoPlayer: UIViewController {
            
            let playerViewController = AVPlayerViewController()
            var player : AVPlayer?
            var videoURL: URL?
            var interviewURL: URL?
            var headline: String?
            var screenSize: CGRect?
            
            func addVideoURL(aVideoURL: URL){
                self.videoURL = aVideoURL
            }
            
            func addInterviewURL(anInterviewURL: URL){
                self.interviewURL = anInterviewURL
            }
            
            func addHeadline(aHeadline: String){
                self.headline = aHeadline
            }
            
            func addScreenSize(aScreenSize: CGRect){
                self.screenSize = aScreenSize
            }
            
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                
                
                let items = [AVPlayerItem(url: interviewURL!), AVPlayerItem(url:videoURL!)]
                let player = AVQueuePlayer(items: items)
                playerViewController.player = player
                /*
                self.present(playerViewController, animated: true) { () -> Void in
                    let label = UILabel()
                    label.text = self.headline
                    label.textAlignment = NSTextAlignment.center
                    label.backgroundColor = UIColor.black
                    label.textColor = UIColor(white: 1, alpha: 0.75)
                    label.font = UIFont.systemFont(ofSize: 15)
                    label.adjustsFontSizeToFitWidth = true
                    label.frame = CGRect(x: 0, y: self.screenSize!.height, width: self.screenSize!.width, height: self.screenSize!.height * 0.1)
                    label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    self.playerViewController.contentOverlayView?.addSubview(label)
                    self.playerViewController.player!.play()
                }
                 */
            }  
        }
         */
        
        /*
        guard let videoURL = URL(string: (self.articles[indexPath.item].url)!) else {return}
        guard let interviewURL = URL(string: (self.articles[indexPath.item].interviewUrl)!) else {return}
 
        var items = [AVPlayerItem(url: interviewURL), AVPlayerItem(url:videoURL)]
        */
        
        var items: [AVPlayerItem] = []
        
        for str in (self.articles[indexPath.item].interviewUrl ?? []){
            if URL(string: str) != nil{
                items.append(AVPlayerItem(url: URL(string: str)!))
            }
        }
        
        for str in (self.articles[indexPath.item].url ?? []){
            if URL(string: str) != nil{
                items.append(AVPlayerItem(url: URL(string: str)!))
            }
        }
        
        for str in (self.articles[indexPath.item].interviewOthers ?? []){
            if URL(string: str) != nil{
                items.append(AVPlayerItem(url: URL(string: str)!))
            }
        }
        
        //let player = AVPlayer(url: videoURL!)
        let player = AVQueuePlayer(items: items)
        
        playerViewController.player = player
        
        
        //let screenSize: CGRect = UIScreen.main.bounds
        
        
        
        //var label = UILabel()
        let articleLocation = CLLocation(latitude: self.articles[indexPath.item].lat ?? 0, longitude: self.articles[indexPath.item].long ?? 0)
        let geoCoder = CLGeocoder()
    
        geoCoder.reverseGeocodeLocation(articleLocation) { (placemarkArray, error) in
            var city = placemarkArray!.first!.locality!
            print("city: \(city)")
            if (error != nil){
                print("geolocator error: \(error)")
            }
            self.label.text = "\(self.articles[indexPath.item].headline ?? "")\n  INSERT DATE HERE | \(city) | by   \(self.articles[indexPath.item].author ?? "")"
            self.label.numberOfLines = 0
            self.label2.text = "\(String(describing: self.articles[indexPath.item].author ?? "unknown author"))'s Story"
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
            
            
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                self.playerViewController.contentOverlayView?.addSubview(self.label)
                self.playerViewController.contentOverlayView?.addSubview(self.label2)
                self.playerViewController.contentOverlayView?.addSubview(self.label3)
                self.playerViewController.contentOverlayView?.addSubview(self.logo)
                self.playerViewController.player?.play()
            }
            /*
             let videoURL = URL(string: (self.articles?[indexPath.item].url)!)
             let interviewURL = URL(string: (self.articles?[indexPath.item].interviewUrl)!)
             let headline = self.articles?[indexPath.item].headline
             let screenSize: CGRect = UIScreen.main.bounds
             
             let playerViewController = OurVideoPlayer()
             playerViewController.addHeadline(aHeadline: headline!)
             playerViewController.addVideoURL(aVideoURL: videoURL!)
             playerViewController.addScreenSize(aScreenSize: screenSize)
             playerViewController.addInterviewURL(anInterviewURL: interviewURL!)
             
             self.present(playerViewController, animated: true) { () -> Void in
             let label = UILabel()
             label.text = headline
             label.textAlignment = NSTextAlignment.center
             label.backgroundColor = UIColor.black
             label.textColor = UIColor(white: 1, alpha: 0.75)
             label.font = UIFont.systemFont(ofSize: 15)
             label.adjustsFontSizeToFitWidth = true
             label.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height * 0.1)
             label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
             playerViewController.playerViewController.contentOverlayView?.addSubview(label)
             playerViewController.player?.play()
             }
             */
            
        }
       
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: (URL(string: url) ?? URL(string: "https://pvsmt99345.i.lithium.com/t5/image/serverpage/image-id/10546i3DAC5A5993C8BC8C?v=1.0")!))
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("check uiimageview extension: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

