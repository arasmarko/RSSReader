//
//  Feed.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import Foundation
import RealmSwift

class Feed: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String? = nil
    var stories: List<Story> = List<Story>()

    convenience init(name: String, imageName: String?, stories: List<Story>) {
        self.init()
        self.name = name
        self.imageName = imageName
        self.stories = stories
    }
}

class FeedRealmService {
    static func add(feed: Feed, in realm: Realm = try! Realm()) {
        try! realm.write {
            realm.add(feed)
        }
    }
}
