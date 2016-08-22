//
//  ProfileTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: "reloadTable", object: nil)
    }
    override func  viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = Utilities.user{
            
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reload(){
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("profile", forIndexPath: indexPath) as! ProfileTableViewCell
            if let user = Utilities.user {
                cell.nameText.text = user.name
                if let image = user.image{
                    cell.profileImage.image = image
                    cell.profileImage.layer.borderWidth = 1
                    cell.profileImage.layer.masksToBounds = false
                    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height/2
                    cell.profileImage.clipsToBounds = true
                }
                
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath)
            if let user = Utilities.user {
                switch indexPath.row {
                case 1:
                    cell.textLabel?.text = "Email: " + user.email
                case 2:
                    cell.textLabel?.text = "Username: " + user.username
                case 3:
                    cell.textLabel?.text = "My posts"
                    cell.textLabel?.textColor = UIColor.blueColor()
                default:
                    cell.textLabel?.text = "My comments"
                    cell.textLabel?.textColor = UIColor.blueColor()

                }
            }
            return cell

        }

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myPosts") as! MyPostsTableViewController
            if let user = Utilities.user {
                viewController.posts = user.posts
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 130.0
        }else{
            return 60.0
        }
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        Utilities.user =  nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
