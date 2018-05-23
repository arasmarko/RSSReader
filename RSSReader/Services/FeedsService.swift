//
//  FeedsService.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RxSwift
import RxRealm
import RealmSwift
import FeedKit

protocol FeedsServiceProtocol {
    func getFeeds() -> Observable<[Feed]>
}

class FeedsService: FeedsServiceProtocol {
    let disposeBag = DisposeBag()
    let feedsFromURL = PublishSubject<Feed>()
    
    init() {}

    func getFeeds() -> Observable<[Feed]> {
        let realm = try! Realm()
        let feeds = realm.objects(Feed.self)

        print("maki", loadFeedsFromUrl())

        feedsFromURL.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (newFeed) in
                FeedRealmService.add(feed: newFeed, in: realm)
            })
            .disposed(by: disposeBag)

        return Observable.array(from: feeds)
            .map({ $0 })

    }

    func loadFeedsFromUrl() {
        var feedURLs: [URL] = []
        let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!
        let feedURL2 = URL(string: "http://feeds.bbci.co.uk/news/world/rss.xml")!
        let feedURL3 = URL(string: "http://www.cbn.com/cbnnews/world/feed/")!
        let feedURL4 = URL(string: "http://feeds.reuters.com/Reuters/worldNews")!
        feedURLs.append(feedURL)
        feedURLs.append(feedURL2)
        feedURLs.append(feedURL3)
        feedURLs.append(feedURL4)

        var parser: FeedParser!

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
            var total = 0
            for url in feedURLs {
                parser = FeedParser(URL: url)
                print("get", url)

                let results = parser.parse()
                switch results {
                case .rss(let feed):
                    total += 1
                    print("IMG", feed.image?.url)
                    let newFeed = self.createFeedWithStories(feed: feed)
                    self.feedsFromURL.onNext(newFeed)
                default:
                    break
                }
            }
            self.feedsFromURL.onCompleted()
        }
    }

    func createFeedWithStories(feed: RSSFeed) -> Feed {
        let stories = List<Story>()
        for story in feed.items ?? [] {
            if let title = story.title,
                let link = story.link,
                let desc = story.description {
                    let s = Story(title: title, link: link, info: desc, imageUrl: nil)
                stories.append(s)
            }

        }
        let feed = Feed(title: feed.title ?? "no title", imageUrl: feed.image?.url, stories: stories)
        return feed
    }
}
