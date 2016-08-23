//
//  PostsTagTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices


class PostsTagTableViewController: UITableViewController,UISearchResultsUpdating {
    var posts:[Post] = []
    var postsSearch:[Post] = []
    var searchController:UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        tableView.estimatedRowHeight = 180.0
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var post:Post?
        if searchController.active{
            post = postsSearch[indexPath.row]
        }else{
            post = posts[indexPath.row]
        }
        let url = "https://unoverflow.herokuapp.com/posts/"+String(post!.id)
        let URL = NSURL(string: url)
        let safariController = SFSafariViewController(URL: URL!)
        self.presentViewController(safariController, animated: true, completion: nil)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postsTag", forIndexPath: indexPath) as! PostTagTableViewCell
        var post:Post?
        if searchController.active{
            post = postsSearch[indexPath.row]
        }else{
            post = posts[indexPath.row]
        }
        cell.titleText.text = post?.title
        cell.descriptionText.text = post?.description.html2String
        cell.created.text = "Created: \(post?.cretedAt)"
        cell.updated.text = "Updated: \(post?.updatedAt)"
        if let user = Utilities.user{
            if post!.owner == user.id{
                cell.myPostText.text = "This post was created for you"
            }else{
                cell.myPostText.text = ""
            }
        }


        return cell
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    func filterContentForSearchText(searchText:String){
        postsSearch = posts.filter({(p:Post) -> Bool in
            let titleMatch = p.title.rangeOfString(searchText,options: .CaseInsensitiveSearch)
            return titleMatch != nil
        })
    }
    
}
