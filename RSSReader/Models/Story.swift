//
//  Story.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift

class Story: Object {
    var title: String = ""
    var link: String = ""
    var info: String = ""
    var imageUrl: String? = nil

    convenience init(title: String, link: String, info: String, imageUrl: String?) {
        self.init()
        self.title = title
        self.link = link
        self.info = info
        self.imageUrl = imageUrl
    }
}
