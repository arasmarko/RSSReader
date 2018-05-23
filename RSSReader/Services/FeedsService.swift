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
            .subscribe(onNext: { (a) in
                print("next", a)
            })

        return Observable.array(from: feeds)
            .debug()
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
        var feed: RSSFeed?
        var parser: FeedParser!

        DispatchQueue.global(qos: .background).async {
            var total = 0
            for url in feedURLs {
                parser = FeedParser(URL: url)
                print("get", url)

                let results = parser.parse()
                switch results {
                case .rss(let feed):
                    total += 1
                    print("IMG", feed.image?.url)
//                    Feed(name: feed.title, imageName: feed.image, stories: <#T##List<Story>#>)
//                    self.feedsFromURL.onNext()
                default:
                    break
                }
            }
        }

        self.feedsFromURL.onCompleted()
    }
}
