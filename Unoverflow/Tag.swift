//
//  Tag.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import Foundation

class Tag{
    var id:Int
    var title:String
    var description:String
    var posts:[Post]
    init(id:Int,title:String,description:String,posts:[Post]){
        self.id = id
        self.title = title
        self.description = description
        self.posts = posts
    }
}