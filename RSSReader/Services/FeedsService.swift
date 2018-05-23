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

protocol FeedsServiceProtocol {
    func getFeeds() -> Observable<[Feed]>
}

class FeedsService: FeedsServiceProtocol {
    let disposeBag = DisposeBag()
    
    init() {
    }
    func getFeeds() -> Observable<[Feed]> {
        let realm = try! Realm()
        let feeds = realm.objects(Feed.self)

        return Observable.array(from: feeds)//.collection(from: feeds)
            .map({ $0 })
//            .subscribe(onNext: { (res) in
//                print("AAA", res)
//            })
//            .disposed(by: disposeBag)
//        let stories: List<Story> = List<Story>()
//        stories.append(Story(id: 1, name: "story 1"))
//        stories.append(Story(id: 2, name: "story 2"))
//        let feed1 = Feed(name: "feed1", imageName: "feed", stories: stories)
//
//        let stories2: List<Story> = List<Story>()
//        stories2.append(Story(id: 3, name: "story 3"))
//        stories2.append(Story(id: 4, name: "story 4"))
//        let feed2 = Feed(name: "feed2", imageName: "feed", stories: stories2)
//
//        FeedRealmService.add(feed: feed1)
//        FeedRealmService.add(feed: feed2)

//        return Observable.just([feed1, feed2])
    }
}
