//
//  Story.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift

class Story: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var info: String = ""
    @objc dynamic var imageUrl: String? = nil

    convenience init(title: String, link: String, info: String, imageUrl: String?) {
        self.init()
        self.title = title
        self.link = link
        self.info = info
        self.imageUrl = imageUrl
    }
}
