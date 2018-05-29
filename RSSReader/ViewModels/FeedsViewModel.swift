//
//  FeedsViewModel.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RxSwift

enum FeedParserError {
    case error(String)
}

protocol FeedsViewModelProtocol {
    var feedItems: Observable<[Feed]>! { get set }
    var newFeedItems: PublishSubject<Int> { get set }
    var newFeedUrlString: PublishSubject<String> { get set }
    var parserError: PublishSubject<String> { get set }
}

class FeedsViewModel: FeedsViewModelProtocol {
    var feedItems: Observable<[Feed]>!
    var newFeedItems = PublishSubject<Int>()
    var newFeedUrlString = PublishSubject<String>()
    var parserError = PublishSubject<String>()

    private let feedsService: FeedsServiceProtocol
    private let disposeBag = DisposeBag()

    init(feedsService: FeedsServiceProtocol) {
        self.feedsService = feedsService

        feedItems = self.feedsService.getFeeds()

        feedsService.parserError
            .asObservable()
            .map({ (error) -> String in
                switch error {
                case .error:
                    return "Sorry but we were not able to process this url."
                }
            })
            .bind(to: parserError)
            .disposed(by: disposeBag)


        feedsService.hasNewFeeds
            .asObservable()
            .bind(to: newFeedItems)
            .disposed(by: disposeBag)

        newFeedUrlString.asObservable()
            .subscribe(onNext: { [weak self] (newUrl) in
                self?.simulateNewStoriesNotification()
                self?.feedsService.saveNewFeedUrlString(newUrl)
            })
            .disposed(by: disposeBag)
    }

    /// This method is user to simulate notification that is sent when there are new stories in your saved feeds.
    private func simulateNewStoriesNotification() {
        newFeedItems.onNext(2)
    }
    
}
