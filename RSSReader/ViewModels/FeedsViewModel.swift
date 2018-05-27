//
//  FeedsViewModel.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RxSwift

protocol FeedsViewModelProtocol {
    var feedItems: Observable<[Feed]>! { get set }
    var newFeedUrlString: PublishSubject<String> { get set }
}

class FeedsViewModel: FeedsViewModelProtocol {
    var feedItems: Observable<[Feed]>!
    var newFeedUrlString = PublishSubject<String>()

    private let feedsService: FeedsServiceProtocol
    private let disposeBag = DisposeBag()

    init(feedsService: FeedsServiceProtocol) {
        self.feedsService = feedsService

        feedItems = self.feedsService.getFeeds()
//            .debug()

        newFeedUrlString.asObservable()
            .subscribe(onNext: { [weak self] (newUrl) in
                self?.feedsService.saveNewFeedUrlString(newUrl)
            })
            .disposed(by: disposeBag)
    }
    
}
