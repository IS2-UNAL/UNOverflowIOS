//
//  User.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import Foundation
import UIKit

class User{
    var id:Int
    var email:String
    var username:String
    var image:UIImage?
    var authToken:String
    var role:String
    var avatar:String{
        didSet{
            let url = NSURL(string: avatar)
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request,completionHandler: {data,response,error -> Void in
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        self.image = UIImage(data: data!)!
                    }
                }
            })
            task.resume()
        }
    }
    var name:String
    var comments:[Comment]
    var posts:[Post]
    init(id:Int,email:String,username:String,avatar:String,name:String,authToken:String,role:String,comments:[Comment],posts:[Post]){
        self.id = id
        self.email = email
        self.username = username
        self.avatar = avatar
        self.name = name
        self.role = role
        self.authToken = authToken
        self.comments = comments
        self.posts = posts
    }
}