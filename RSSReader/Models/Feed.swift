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
        let feed = Feed(title: feedData.title ?? "no title", imageUrl: feedData.image?.url, stories: stories)
        feed.stories = stories
        return feed
    }

    /// appends new stories to feed
    /// - Returns: number of inserted stories
    func updateStories(from anotherFeed: Feed) -> Int {
        // TODO - find better solution for distincting
        var existingStoryTitles = Set<String>(stories.map({ $0.title }))
        var storiesToInsert = [Story]()
        
        for newStory in anotherFeed.stories {
            if existingStoryTitles.index(of: newStory.title) == nil {
                existingStoryTitles.insert(newStory.title)
                storiesToInsert.append(newStory)
            }
        }

        if storiesToInsert.count > 0 {
            appendNewStoriesAndAddBadge(storiesToInsert)
            return storiesToInsert.count
        }
        return 0
    }

    private func appendNewStoriesAndAddBadge(_ storiesToInsert: [Story]) {
        let oldCount = stories.count
        stories.append(objectsIn: storiesToInsert)
        UIApplication.shared.applicationIconBadgeNumber = stories.count - oldCount
    }
}
