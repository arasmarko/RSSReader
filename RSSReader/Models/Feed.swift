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
    @objc dynamic var title: String = ""
    @objc dynamic var imageUrl: String? = nil
    var stories: List<Story> = List<Story>()

    convenience init(title: String, imageUrl: String?, stories: List<Story>) {
        self.init()
        self.title = title
        self.imageUrl = imageUrl
        self.stories = stories
    }
}

class FeedRealmService {
    /// Adds Feed to Realm and makes sure it is uniq
    static func add(feed: Feed, in realm: Realm = try! Realm()) {
        let isFeedUniq = realm.objects(Feed.self).filter("title = '\(feed.title)'").isEmpty
        guard isFeedUniq else { return }
        try! realm.write {
            realm.add(feed)
        }
    }
}
