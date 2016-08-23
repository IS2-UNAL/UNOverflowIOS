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
    var owner:Int
    var postId:Int
    init(id:Int,answer:String,createdAt:String,updatedAt:String,owner:Int,postId:Int){
        self.id = id
        self.answer = answer
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.owner = owner
        self.postId = postId
    }
}