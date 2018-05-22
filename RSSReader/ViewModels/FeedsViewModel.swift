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
}

class FeedsViewModel: FeedsViewModelProtocol {
    var feedItems: Observable<[Feed]>!

    private let feedsService: FeedsServiceProtocol
    private let disposeBag = DisposeBag()

    init(feedsService: FeedsServiceProtocol) {
        self.feedsService = feedsService

        feedItems = self.feedsService.getFeeds()
    }
    
}
