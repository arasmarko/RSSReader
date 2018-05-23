//
//  Story.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift

class Story: Object {
    var id: Int = -1
    var name: String = ""

    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
}
