//
//  MyCommentsTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices


class MyCommentsTableViewController: UITableViewController,UISearchResultsUpdating {
    var myComments:[Comment] = []
    var myCommentsSearch:[Comment] = []
    var searchController:UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.refreshControl?.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)

    }
    func handleRefresh(){
        let URL = "http://unoverflow.herokuapp.com/api/v1/users/reloadUser"
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!,cachePolicy: .UseProtocolCachePolicy,timeoutInterval: 10.0)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        if let user = Utilities.user{
            let params = ["api_token":user.authToken]
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request, completionHandler: {data,response,error -> Void in
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                            let user = Utilities.parseJSONToUser(json)
                            Utilities.user = user
                            self.myComments =  (user?.comments)!
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        })
                        
                    }
                }
            })
            task.resume()
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active{
            return myCommentsSearch.count
        }
        return myComments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as! CommentTableViewCell
        var comment:Comment?
        if searchController.active{
            comment = myCommentsSearch[indexPath.row]
        }else{
            comment = myComments[indexPath.row]
        }
        cell.answerText.text = comment!.answer.html2String
        cell.created.text = "Created: " + String(comment!.createdAt)
        cell.updated.text = "Updated: " + String(comment!.updatedAt)

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let viewComment = UITableViewRowAction(style: .Default, title: "View", handler: {(action,indexPath) -> Void in
            let comment =  self.myComments[indexPath.row]
            let url = "https://unoverflow.herokuapp.com/comments/"+String(comment.id)
            let URL = NSURL(string: url)
            let safariController = SFSafariViewController(URL: URL!)
            self.presentViewController(safariController, animated: true, completion: nil)
        })
        let deleteComment =  UITableViewRowAction(style: .Default, title: "Delete", handler: {(action,indexPath)-> Void in
            let comment = self.myComments[indexPath.row]
            let url = NSURL(string: "https://unoverflow.herokuapp.com/api/v1/comments_api/"+String(comment.id))
            let request = NSMutableURLRequest(URL: url!,cachePolicy:.UseProtocolCachePolicy, timeoutInterval: 10.0)
            request.HTTPMethod = "DELETE"
            if let user = Utilities.user{
                let params = ["api_token":user.authToken]
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
                request.addValue("application/json", forHTTPHeaderField: "Content-type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: {data,response,error -> Void in
                    if let httpResponse = response as? NSHTTPURLResponse{
                        if httpResponse.statusCode == 204{
                            NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in
                                self.myComments.removeAtIndex(indexPath.row)
                                self.tableView.reloadData()
                                self.handleRefresh()
                                self.presentViewController(Utilities.alertMessage("Success", message: "The comment was deleted"), animated: true, completion: nil)
                            })
                        }else{
                            NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in
                                self.presentViewController(Utilities.alertMessage("Error", message: "We couldn't delete the comment"), animated: true, completion: nil)
                            })
                            
                        }
                    }
                })
                task.resume()
                
            }
            
            
        })
        deleteComment.backgroundColor = UIColor.redColor()
        viewComment.backgroundColor = UIColor.blueColor()
        return [viewComment,deleteComment]
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    func filterContentForSearchText(searchText:String){
        myCommentsSearch = myComments.filter({(c:Comment) -> Bool in
            let answerMatch = c.answer.rangeOfString(searchText,options: .CaseInsensitiveSearch)
            return answerMatch != nil
        })
    }

    

}
