//
//  Feed.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import Foundation
import RealmSwift
import FeedKit

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

    static func createFeedWithStories(from feedData: RSSFeed) -> Feed {
        let stories = List<Story>()
        for story in feedData.items ?? [] {
            if let title = story.title,
                let link = story.link,
                let desc = story.description {
                let newStory = Story(title: title, link: link, info: desc, imageUrl: nil)
                stories.append(newStory)
            }
        }
        print("createFeedWithStories", feedData.title, stories.first?.title)
        let feed = Feed(title: feedData.title ?? "no title", imageUrl: feedData.image?.url, stories: stories)
        feed.stories = stories
        return feed
    }

    func updateStories(from anotherFeed: Feed) {
        // TODO - find better solution for distincting
        var existingStories = Set<Story>(stories)

        for newStory in anotherFeed.stories {
            existingStories.insert(newStory)
        }

        stories.removeAll()
        stories.append(objectsIn: existingStories)
    }
}
