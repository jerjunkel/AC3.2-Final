//
//  Meatly.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Post{
    let key: String
    let userId: String
    let comment: String

   init(key: String,dict: [String:String]){
    
        self.key = key
        self.comment = dict["comment"] ?? " "
        self.userId = dict["userId"] ?? " "

    }
    
    var asDictionary: [String:String]{
        return ["userId":userId,"comment":comment]
    }
}
