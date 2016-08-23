//
//  TagsTableViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 22/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices


class TagsTableViewController: UITableViewController {
    var tags:[Tag] = []
    var tasks:[NSURLSessionDataTask] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 110.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tags.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tags", forIndexPath: indexPath) as! TagTableViewCell
        
        let tag = tags[indexPath.row]
        cell.titleText.text = tag.title
        cell.descriptionText.text = tag.description.html2String
        cell.postCountText.text = "This tag has \(tag.posts.count) posts"

        return cell
    }
    
    @IBAction func addTag(sender: AnyObject) {
        let url = NSURL(string: "https://unoverflow.herokuapp.com/admin/tags")
        let safariController = SFSafariViewController(URL: url!)
        presentViewController(safariController, animated: true, completion: nil)
    }

    

    
    

}
