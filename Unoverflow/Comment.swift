//
//  Comment.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import Foundation
import UIKit

class Comment{
    var id:Int
    var answer:String
    var createdAt:String
    var updatedAt:String
    var images:[String]?{
        didSet{
            imagesUI = []
            for url in images!{
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
    var imagesUI:[UIImage?] = []
    var owner:Int
    init(id:Int,answer:String,createdAt:String,updatedAt:String,owner:Int){
        self.id = id
        self.answer = answer
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.owner = owner
    }
}