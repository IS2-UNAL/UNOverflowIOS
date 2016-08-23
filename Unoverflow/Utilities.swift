//
//  Utilities.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    static var user:User?
    static func alertMessage(title:String,message:String) -> UIAlertController{
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertMessage.addAction(okAction)
        return alertMessage
    }
    static func parseJSONToTags(json:NSDictionary) -> [Tag]{
        var tagsTemp:[Tag] = []
        let tags = json["tags_api"] as! [AnyObject]
        for t in tags{
            let _id = t["id"] as! Int
            let _title = t["title"] as! String
            let _description = t["description"] as! String
            var _posts:[Post] = []
            let postJSON = t["posts"] as! [AnyObject]
            for p in postJSON{
                let _idPost = p["id"] as! Int
                let _titlePost = p["title"] as! String
                let _descriptionPost = p["description"] as! String
                let _createdAt = p["created_at"] as! String
                let _updatedAt = p["updated_at"] as! String
                let _owner = p["user_id"] as! Int
                let post = Post(id: _idPost, title: _titlePost, description: _descriptionPost, createdAt: _createdAt, updatedAt: _updatedAt, owner: _owner)
                _posts.append(post)
            }
            
            let tag = Tag(id: _id, title: _title, description: _description, posts: _posts)
            tagsTemp.append(tag)
        }
        return tagsTemp
    }
    static func parseJSONToUser(json:NSDictionary) -> User?{
        let user = json["user"] as! NSDictionary
        let _id = user["id"] as! Int
        let _email = user["email"] as! String
        let _username = user["username"] as! String
        let _name = user["name"] as! String
        let _role = user["role"] as! String
        let _authToken = user["auth_token"] as! String
        let avatar = user["avatar"] as! NSDictionary
        let avatarURLs = avatar["avatar"] as! NSDictionary
        let thumb = avatarURLs["thumb"] as! NSDictionary
        let _thumbURL = thumb["url"] as! String
        
        var _comments:[Comment] = []
        let commentsJSON = user["comments"] as! [AnyObject]
        for comment in commentsJSON{
            let _idComment = comment["id"] as! Int
            let _answer = comment["answer"] as! String
            let _createdAt = comment["created_at"] as! String
            let _updatedAt = comment["updated_at"] as! String
            let _ownerComment = comment["user_id"] as! Int
            let _postIdComment = comment["post_id"] as! Int
            let commentTemp = Comment(id: _idComment, answer: _answer, createdAt: _createdAt, updatedAt: _updatedAt, owner: _ownerComment,postId: _postIdComment)
            _comments.append(commentTemp)
            
        }
        var _posts:[Post] = []
        let postsJSON = user["post"] as! [AnyObject]
        for post in postsJSON{
            let _idPost = post["id"] as! Int
            let _title = post["title"] as! String
            let _description = post["description"] as! String
            let _createdAtPost = post["created_at"] as! String
            let _updatedAtPost = post["updated_at"] as! String
            let _ownerPost = post["user_id"] as! Int
            
            let postTemp = Post(id: _idPost, title: _title, description: _description, createdAt: _createdAtPost, updatedAt: _updatedAtPost, owner: _ownerPost)
            _posts.append(postTemp)
        }
        let userTemp = User(id: _id, email: _email, username: _username,  name: _name, authToken: _authToken, role: _role, comments: _comments, posts: _posts)
        userTemp.avatar = _thumbURL
        return userTemp
        
    }
}