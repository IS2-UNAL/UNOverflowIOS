//
//  TagsTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices


class TagsTableViewController: UITableViewController,UISearchResultsUpdating {
    var tags:[Tag] = []
    var tagsDictionary:[String:[Tag]] = [:]
    var tagTitles:[String] = []
    var tagsSearch:[Tag] = []
    var tasks:[NSURLSessionDataTask] = []
    var searchController:UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController =  UISearchController(searchResultsController: nil)
        tableView.estimatedRowHeight = 110.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getTags()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        for t in tasks{
            t.cancel()
        }
    }
    func getTags(){
        tags = []
        tagsDictionary = [:]
        tagTitles = []
        tableView.reloadData()
        getTagsFromUrl("https://unoverflow.herokuapp.com/api/v1/tags_api.json",page: 1)
    }
    func getTagsFromUrl(url:String,page:Int){
        var newURL:String = url
        if page != 1{
            newURL = url + "?page=\(page)"
        }
        let URL = NSURL(string: newURL)
        let request = NSURLRequest(URL: URL!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10.0)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:{data,response,error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                   let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                        let tags = Utilities.parseJSONToTags(json)
                        self.tags.appendContentsOf(tags)
                        self.tableView.reloadData()
                        self.createDictionary()
                    })
                    
                    let meta = json["meta"] as! NSDictionary
                    let pagination = meta["pagination"] as! NSDictionary
                    let nextPage:Int? = pagination["next_page"] as? Int
                    if let _ = nextPage{
                        self.getTagsFromUrl("https://unoverflow.herokuapp.com/api/v1/tags_api.json", page: nextPage!)
                    }
                }
            }
        })
        tasks.append(task)
        task.resume()
    }
    func createDictionary(){
        tagsDictionary = [:]
        for t in tags{
            let key = t.title.substringToIndex(t.title.startIndex.advancedBy(1)).lowercaseString
            if var tagsTemp = tagsDictionary[key]{
                tagsTemp.append(t)
                tagsDictionary[key] = tagsTemp
            }else{
                tagsDictionary[key] = [t]
            }
        }
        tagTitles = [String](tagsDictionary.keys)
        tagTitles = tagTitles.sort({ $0 < $1 })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active{
            return 1
        }
        return tagTitles.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active{
            return tagsSearch.count
        }else{
            let key = tagTitles[section]
            if let tags = tagsDictionary[key]{
                return tags.count
            }
            return 0
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.active{
            return nil
        }
        return tagTitles[section]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchController.active{
            let cell = tableView.dequeueReusableCellWithIdentifier("tags", forIndexPath: indexPath) as! TagTableViewCell
            let tag = tagsSearch[indexPath.row]
            cell.titleText.text = tag.title
            cell.descriptionText.text = tag.description.html2String
            cell.postCountText.text = "This tag has \(tag.posts.count) posts"
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("tags", forIndexPath: indexPath) as! TagTableViewCell
            let key = tagTitles[indexPath.section]
            if let tags = tagsDictionary[key]{
                let tag = tags[indexPath.row]
                cell.titleText.text = tag.title
                cell.descriptionText.text = tag.description.html2String
                cell.postCountText.text = "This tag has \(tag.posts.count) posts"
                
                return cell
            }
            return cell
        }
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if searchController.active{
            return nil
        }
        return tagTitles
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
    }

    func updateSearchResultsForSearchController(searchController:UISearchController){
        if let searchText = searchController.searchBar.text{
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    func filterContentForSearchText(searchText:String){
        tagsSearch = tags.filter({(t:Tag)-> Bool in
            let titleMatch = t.title.rangeOfString(searchText,options: .CaseInsensitiveSearch)
            return titleMatch != nil
        })
    }
    
    @IBAction func addTag(sender: AnyObject) {
        let url = NSURL(string: "https://unoverflow.herokuapp.com/admin/tags")
        let safariController = SFSafariViewController(URL: url!)
        presentViewController(safariController, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let viewTag = UITableViewRowAction(style: .Default, title: "View", handler: {(action,indexPath) -> Void in
            let key = self.tagTitles[indexPath.section]
            if let tags = self.tagsDictionary[key]{
                let tag =  tags[indexPath.row]
                let url = "https://unoverflow.herokuapp.com/admin/tags/"+String(tag.id)
                let URL = NSURL(string: url)
                let safariController = SFSafariViewController(URL: URL!)
                self.presentViewController(safariController, animated: true, completion: nil)
            }
        })
        viewTag.backgroundColor = UIColor.blueColor()
        return [viewTag]
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    

    

    
    

}
