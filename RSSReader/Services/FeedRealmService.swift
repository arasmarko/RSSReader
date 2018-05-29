//
//  FeedRealmService.swift
//  RSSReader
//
//  Created by Marko Aras on 27/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift
import RxSwift

class FeedRealmService {
    var realm: Realm!
    var hasNewFeeds = PublishSubject<Int>()

    /// Adds or Updates Feed to Realm and makes sure it is unique
    func syncRealmWithNewData(feed: Feed, in realm: Realm = try! Realm()) {
        self.realm = realm
        let feedFromRealm = realm.objects(Feed.self).filter("title = '\(feed.title)'").first

        if let oldFeed = feedFromRealm {
            updateFeedWithNewStories(oldFeed, newFeed: feed)
            return
        }

        try! realm.write {
            realm.add(feed)
        }
    }

    private func updateFeedWithNewStories(_ oldFeed: Feed, newFeed: Feed) {
        try! realm.write {
            hasNewFeeds.onNext(oldFeed.updateStories(from: newFeed))
        }
    }
}
