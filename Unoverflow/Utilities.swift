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
            let imagesComment = comment["images"] as! [AnyObject]
            var _imagesComment:[String] = []
            for img in imagesComment{
                let imgJSON = img["image"] as! NSDictionary
                let imgURL = imgJSON["url"] as! String
                _imagesComment.append(imgURL)
            }
            let commentTemp = Comment(id: _idComment, answer: _answer, createdAt: _createdAt, updatedAt: _updatedAt, owner: _ownerComment)
            commentTemp.images = _imagesComment
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
            var _commentPost:[Comment] = []
            let commentsPostJSON = post["comments"] as! [AnyObject]
            for c in commentsPostJSON{
                let _idCommentPost = c["id"] as! Int
                let _answerPost = c["answer"] as! String
                let _createdAtPostComment = c["created_at"] as! String
                let _updatedAtPostComment = c["updated_at"] as! String
                let _ownerPostComment = c["user_id"] as! Int
                let imagesPostComment = c["images"] as! [AnyObject]
                var _imagesPostComment:[String] = []
                for img in imagesPostComment{
                    let imgJSON = img["image"] as! NSDictionary
                    let imgURL = imgJSON["url"] as! String
                    _imagesPostComment.append(imgURL)
                }
                let commentTemp = Comment(id: _idCommentPost, answer: _answerPost, createdAt: _createdAtPostComment, updatedAt: _updatedAtPostComment,  owner: _ownerPostComment)
                commentTemp.images = _imagesPostComment
                _commentPost.append(commentTemp)
                
            }
            var _imagesPost:[String] = []
            let imagesPostJSON = post["images"] as! [AnyObject]
            for img in imagesPostJSON{
                let imgJSON = img["image"] as! NSDictionary
                let imgURL = imgJSON["url"] as! String
                _imagesPost.append(imgURL)
            }
            let postTemp = Post(id: _idPost, title: _title, description: _description, createdAt: _createdAtPost, updatedAt: _updatedAtPost, comments: _commentPost, owner: _ownerPost)
            postTemp.images = _imagesPost
            _posts.append(postTemp)
        }
        let userTemp = User(id: _id, email: _email, username: _username,  name: _name, authToken: _authToken, role: _role, comments: _comments, posts: _posts)
        userTemp.avatar = _thumbURL
        return userTemp
        
    }
}