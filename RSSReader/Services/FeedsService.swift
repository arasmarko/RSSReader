//
//  FeedsService.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RxSwift

protocol FeedsServiceProtocol {
    func getFeeds() -> Observable<[Feed]>
}

class FeedsService: FeedsServiceProtocol {
    func getFeeds() -> Observable<[Feed]> {
        var stories = Set<Story>()
        stories.insert(Story(id: 1, name: "story 1"))
        stories.insert(Story(id: 2, name: "story 2"))
        let feed1 = Feed(name: "feed1", image: #imageLiteral(resourceName: "feed"), stories: stories)

        var stories2 = Set<Story>()
        stories2.insert(Story(id: 3, name: "story 3"))
        stories2.insert(Story(id: 4, name: "story 4"))
        let feed2 = Feed(name: "feed2", image: #imageLiteral(resourceName: "feed"), stories: stories2)

        return Observable.just([feed1, feed2])
    }
}
