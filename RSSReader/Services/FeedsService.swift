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
    func saveNewFeedUrlString(_ new: String)
}

class FeedsService: FeedsServiceProtocol {
    private let disposeBag = DisposeBag()
    private let feedsFromURL = PublishSubject<Feed>()

    private let savedFeedsListService = SavedFeedsListService()
    private let feedRealmService = FeedRealmService()

    let realm = try! Realm()

    func getFeeds() -> Observable<[Feed]> {
        let feeds = realm.objects(Feed.self)

        addDefaultRssFeedLinksToLocalDatabase()

        loadFeedsFromUrl()
        observeOnFeedsFromURL()

        return Observable.collection(from: feeds)//.array(from: feeds)
            .map({ $0.toArray() })
            .do(onNext: { (feeds) in
                print("Observable.array", feeds.count, feeds.first?.title, feeds.first?.stories.first?.title)
            })
    }

    func observeOnFeedsFromURL() {
        feedsFromURL.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newFeed) in
                guard let `self` = self else { return }
                print("observeOnFeedsFromURL", newFeed.title, newFeed.stories.first?.title)
                self.feedRealmService.syncRealmWithNewData(feed: newFeed)
            })
            .disposed(by: disposeBag)
    }

    func loadFeedsFromUrl() {
        let feedURLs: [URL] = savedFeedsListService.urlStrings.map { URL(string: $0.urlString)! }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }

            for url in feedURLs {
                self.loadFeedFromUrl(url: url)
            }
        }
    }

    private func loadFeedFromUrl(url: URL) {
        var parser: FeedParser!
        parser = FeedParser(URL: url)
        let results = parser.parse()
        switch results {
        case .rss(let feedData):
            print("loaded FeedFromUrl", feedData.title, feedData.items?.count, feedData.items?.last?.title)
            createFeedFromDataAndSaveToRealm(data: feedData)
        default:
            break
        }
    }

    private func createFeedFromDataAndSaveToRealm(data: RSSFeed) {
        let newFeed = Feed.createFeedWithStories(from: data)
        self.feedsFromURL.onNext(newFeed)
    }

    // TODO
    func saveNewFeedUrlString(_ new: String) {
        guard let url = URL(string: new) else { return }
        do {
            try savedFeedsListService.saveNewFeedUrlString(urlString: new)

            var parser: FeedParser!

            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let `self` = self else { return }
                parser = FeedParser(URL: url)

                let results = parser.parse()
                switch results {
                case .rss(let feed):
                    self.createFeedFromDataAndSaveToRealm(data: feed)
                default:
                    break
                }
            }
        } catch {
            print("item already saved")
        }
    }

    private func addDefaultRssFeedLinksToLocalDatabase() {
        try? savedFeedsListService.saveNewFeedUrlString(urlString: "http://images.apple.com/main/rss/hotnews/hotnews.rss")
    }
}
