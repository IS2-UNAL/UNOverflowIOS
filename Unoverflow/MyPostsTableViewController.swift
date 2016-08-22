//
//  MyPostsTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices

class MyPostsTableViewController: UITableViewController,UISearchResultsUpdating {
    var posts:[Post] = []
    var postsSearch:[Post] = []
    var searchController:UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active{
            return postsSearch.count
        }
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        var post:Post?
        if searchController.active{
            post = postsSearch[indexPath.row]
        }else{
            post = posts[indexPath.row]
        }
        
        cell.titleText.text = post!.title
        cell.descriptionText.text = post!.description.html2String
        cell.created.text = "Created: " + post!.cretedAt
        cell.updated.text = "Updated: " + post!.updatedAt
        return cell
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let viewPost = UITableViewRowAction(style: .Default, title: "View", handler: {(action,indexPath) -> Void in
            let post =  self.posts[indexPath.row]
            let url = "https://unoverflow.herokuapp.com/posts/"+String(post.id)
            let URL = NSURL(string: url)
            let safariController = SFSafariViewController(URL: URL!)
            self.presentViewController(safariController, animated: true, completion: nil)
        })
        let deletePost =  UITableViewRowAction(style: .Default, title: "Delete", handler: {(action,indexPath)-> Void in
            let post = self.posts[indexPath.row]
            let url = NSURL(string: "https://unoverflow.herokuapp.com/api/v1/posts_api/"+String(post.id))
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
                                self.posts.removeAtIndex(indexPath.row)
                                self.tableView.reloadData()
                                self.presentViewController(Utilities.alertMessage("Success", message: "The post was deleted"), animated: true, completion: nil)
                            })
                        }else{
                            NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in
                                self.presentViewController(Utilities.alertMessage("Error", message: "We couldn't delete the post"), animated: true, completion: nil)
                            })

                        }
                    }
                })
                task.resume()
                
            }
            
            
        })
        deletePost.backgroundColor = UIColor.redColor()
        viewPost.backgroundColor = UIColor.blueColor()
        return [viewPost,deletePost]
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    func filterContentForSearchText(searchText:String){
        postsSearch = posts.filter({(p:Post) -> Bool in
            let titleMatch = p.title.rangeOfString(searchText,options: NSStringCompareOptions.CaseInsensitiveSearch)
            return titleMatch != nil
        })
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
}
extension String{
    var html2AttributedString:NSAttributedString? {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        do{
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        }catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    var html2String:String{
        return html2AttributedString?.string ?? ""
    }
    
}
