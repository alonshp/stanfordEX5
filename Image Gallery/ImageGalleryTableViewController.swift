//
//  ImageGalleryTableViewController.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/1/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var imageGalleryDocuments = ["template1", "template2"]
    var recentlyDeletedDocuments = ["deleted1", "deleted2"]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? imageGalleryDocuments.count : recentlyDeletedDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        if indexPath.section == 0 {
        cell.textLabel?.text = imageGalleryDocuments[indexPath.row]
        } else {
            cell.textLabel?.text = recentlyDeletedDocuments[indexPath.row]
        }

        return cell
    }
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        imageGalleryDocuments += ["Untitled".madeUnique(withRespectTo: imageGalleryDocuments)]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Recently Deleted"
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 {
            return true
        } else {
            return true
        }
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 1 {
                recentlyDeletedDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let deletedImageGallery = imageGalleryDocuments[indexPath.row]
                imageGalleryDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                recentlyDeletedDocuments += [deletedImageGallery]
                tableView.reloadData()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
