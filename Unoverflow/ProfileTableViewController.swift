//
//  ProfileTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController,UIViewControllerPreviewingDelegate {

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
        tableView.reloadData()

        if traitCollection.forceTouchCapability == .Available{
            registerForPreviewingWithDelegate(self, sourceView: view)
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
        if indexPath.row == 4 {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myComments") as! MyCommentsTableViewController
            if let user = Utilities.user {
                viewController.myComments = user.comments
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

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else{
            return nil
        }
        if indexPath.row < 3{
            return nil
        }
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else{
            return nil
        }
        switch indexPath.row {
        case 3:
            let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myPosts") as! MyPostsTableViewController
            if let user = Utilities.user {
                viewController.posts = user.posts
            }
            viewController.preferredContentSize = CGSize(width: 0.0, height: 450.0)
            
            previewingContext.sourceRect = cell.frame
            return viewController
        default:
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myComments") as! MyCommentsTableViewController
            if let user = Utilities.user {
                viewController.myComments = user.comments
                viewController.preferredContentSize = CGSize(width: 0.0, height: 450.0)
                
                previewingContext.sourceRect = cell.frame
                return viewController
            }

        }
        return nil
    }
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)

    }
}
