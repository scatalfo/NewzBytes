//
//  TableViewCommentaryViewController.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 10/11/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVFoundation

class TableViewCommentaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // The current VisibleIndexPath,
    //it can be an array, but for now,
    //i am targetting one cell only
    //var visibleIP : IndexPath?
    
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var firstLoad = true
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        //Your model to hold the videos in the video URL
        for i in 0..<2{
            let url = Bundle.main.url(forResource:"\(i+1)", withExtension: "mp4")
            videoURLs.append(url!)
        }
        // initialized to first indexpath
        visibleIP = IndexPath.init(row: 0, section: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
}
