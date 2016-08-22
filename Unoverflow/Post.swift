//
//  Post.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import Foundation
import UIKit

class Post{
    var id:Int
    var title:String
    var description:String
    var cretedAt:String
    var updatedAt:String
    var comments:[Comment]
    var imagesUI:[UIImage?] = []
    var images:[String]{
        didSet{
            imagesUI = []
            for url in images{
                let URL = NSURL(string: url)
                let request = NSURLRequest(URL: URL!)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: {data,response,error -> Void in
                    if let httpResponse = response as? NSHTTPURLResponse{
                        if httpResponse.statusCode == 200 {
                            self.imagesUI.append(UIImage(data: data!))
                        }
                    }
                })
                task.resume()
                
            }
        }
    }
    var owner:Int
    init(id:Int,title:String,description:String,createdAt:String,updatedAt:String,comments:[Comment],images:[String],owner:Int){
        self.id = id
        self.title = title
        self.description = description
        self.cretedAt = createdAt
        self.updatedAt = updatedAt
        self.comments = comments
        self.images = images
        self.owner = owner
    }
}