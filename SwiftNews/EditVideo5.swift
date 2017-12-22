//
//  EditVideo5.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 10/22/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVFoundation

class EditVideo5: UIViewController, ABVideoRangeSliderDelegate {
    
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var videoContainer: UIView!
    @IBOutlet var rangeSlider: ABVideoRangeSlider!
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    var startTime = 0.0;
    var endTime = 0.0;
    var progressTime = 0.0;
    var shouldUpdateProgressIndicator = true
    var isSeeking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let path = Bundle.main.path(forResource: "test", ofType:"mp4")!
        
        //let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(url: URL(string: commentaryArray.last!)!)
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        videoContainer.layer.insertSublayer(avPlayerLayer, at: 0)
        videoContainer.layer.masksToBounds = true
        rangeSlider.minSpace = 0
        let customView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 60,
                                              height: 40))
        customView.backgroundColor = .black
        customView.alpha = 0
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.borderWidth = 1.0
        customView.layer.cornerRadius = 8.0
        rangeSlider.startTimeView.backgroundView = customView
        rangeSlider.endTimeView.backgroundView = customView
        rangeSlider.setVideoURL(videoURL: URL(string: commentaryArray.last!)!)
        rangeSlider.delegate = self
        
        self.endTime = CMTimeGetSeconds((avPlayer.currentItem?.duration)!)
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.01, 100)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval,
                                                        queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                            self.observeTime(elapsedTime: elapsedTime) } as AnyObject!
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avPlayerLayer.frame = videoContainer.bounds
    }
    
    @IBAction func playTapped(_ sender: Any) {
        avPlayer.play()
        shouldUpdateProgressIndicator = true
        btnPlay.isEnabled = false
        btnPause.isEnabled = true
    }
    
    @IBAction func pauseTapped(_ sender: Any) {
        avPlayer.pause()
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        
        if (avPlayer.currentTime().seconds > self.endTime){
            avPlayer.pause()
            btnPlay.isEnabled = true
            btnPause.isEnabled = false
        }
        
        if self.shouldUpdateProgressIndicator{
            rangeSlider.updateProgressIndicator(seconds: elapsedTime)
        }
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        self.shouldUpdateProgressIndicator = false
        
        // Pause the player
        avPlayer.pause()
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        
        if self.progressTime != position {
            self.progressTime = position
            let timescale = self.avPlayer.currentItem?.asset.duration.timescale
            let time = CMTimeMakeWithSeconds(self.progressTime, timescale!)
            if !self.isSeeking{
                self.isSeeking = true
                avPlayer.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero){_ in
                    self.isSeeking = false
                }
            }
        }
        
    }
    
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        
        self.endTime = endTime
        
        if startTime != self.startTime{
            self.startTime = startTime
            
            let timescale = self.avPlayer.currentItem?.asset.duration.timescale
            let time = CMTimeMakeWithSeconds(self.startTime, timescale!)
            if !self.isSeeking{
                self.isSeeking = true
                avPlayer.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero){_ in
                    self.isSeeking = false
                }
            }
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
    @IBAction func pressedDone(_ sender: Any) {
        avPlayer.pause()
        cropVideo(sourceURL1: URL(string: commentaryArray.last!)!, statTime: Float(startTime), endTime: Float(endTime))
        performSegue(withIdentifier: "editToAllThree2", sender: nil)
    }
    func cropVideo(sourceURL1: URL, statTime:Float, endTime:Float){
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        let mediaType = "mp4"
        let url = sourceURL1
        
        //if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
        let asset = AVAsset(url: url)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")
        
        let start = statTime
        let end = endTime
        
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            let name = randomString(length: 10)
            outputURL = outputURL.appendingPathComponent("\(name).mp4")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)
        
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        
        let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
        let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously{
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                //self.saveVideoTimeline(outputURL)
                commentaryArray.popLast()
                commentaryArray.append(outputURL.absoluteString)
                AllThree.updatePlayer()
            case .failed:
                print("failed \(exportSession.error)")
                
            case .cancelled:
                print("cancelled \(exportSession.error)")
                
            default: break
            }
        }
        
    }
}

