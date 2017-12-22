//
//  ReorderTableView.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 11/3/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

var commentaryIndexPathItem: Int = -1

class ReorderTableView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isEditing = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool{
        return false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentaryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reorderCell", for: indexPath) as! ReorderCell

        // Configure the cell...
        
        cell.thumbnail.image = AVAsset(url: URL(string: commentaryArray[indexPath.item])!).videoThumbnail ?? #imageLiteral(resourceName: "noImageAvailable")
        
        cell.playButton.addTarget(self, action: #selector(self.playButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        //cell.playButton.indexPath = indexPath
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        //cell.deleteButton.indexPath = indexPath
        cell.editButton.addTarget(self, action: #selector(self.editButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        //cell.editButton.indexPath = indexPath
        
        
        
        return cell
    }
    
    @objc func playButtonClicked(sender: UIButton){
        var items: [AVPlayerItem] = []
        
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath = tableView.indexPathForRow(at: point)!
        //for str in commentaryArray{
        let str = commentaryArray[indexPath.item]
        if URL(string: str) != nil{
            items.append(AVPlayerItem(url: URL(string: str)!))
        }
        //}
        
        let player = AVQueuePlayer(items: items)
        
        let AVPController = AVPlayerViewController()
        AVPController.player = player
        
        self.present(AVPController, animated: true, completion: {
            AVPController.player?.play()
        })
    }
    
    @objc func deleteButtonClicked(sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath = tableView.indexPathForRow(at: point)!
        commentaryArray.remove(at: indexPath.item)
        self.tableView.reloadData()
    }
    
    @objc func editButtonClicked(sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath = tableView.indexPathForRow(at: point)!
        if (commentaryArray.count > commentaryIndexPathItem){
            commentaryIndexPathItem = indexPath.item
            self.performSegue(withIdentifier: "generalEditVideo", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "No video to edit", message: "Please add a video.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped")

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
     */

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = commentaryArray[sourceIndexPath.row]
        commentaryArray.remove(at: sourceIndexPath.row)
        commentaryArray.insert(movedObject, at: destinationIndexPath.row)
    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

