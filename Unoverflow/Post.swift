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
    var owner:Int
    init(id:Int,title:String,description:String,createdAt:String,updatedAt:String,owner:Int){
        self.id = id
        self.title = title
        self.description = description
        self.cretedAt = createdAt
        self.updatedAt = updatedAt
        self.owner = owner
    }
}