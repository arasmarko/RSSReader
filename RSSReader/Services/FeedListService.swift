//
//  FeedListService.swift
//  RSSReader
//
//  Created by Marko Aras on 24/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift

class SavedFeedsListService {
    var urlStrings: [FeedUrlString] = []
    let realm = try! Realm()

    enum FeedUrlError: Error {
        case notUnique
    }

    init() {
        getFromRealmToArray()
    }

    func getFromRealmToArray() {
        urlStrings = Array(realm.objects(FeedUrlString.self))
    }

    func saveNewFeedUrlString(urlString: String) throws {
        let toSave = FeedUrlString(urlString)
        let saved = realm.objects(FeedUrlString.self)

        if saved.contains(where: { $0.urlString == toSave.urlString}) {
            throw FeedUrlError.notUnique
        }

        try! realm.write {
            realm.add(toSave)
        }

        getFromRealmToArray()
    }

    func remove(urlString: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let saved = self.realm.objects(FeedUrlString.self)

            guard let urlToDelete = saved.filter({ $0.urlString == urlString}).first else {
                return
            }

            try! self.realm.write {
                self.realm.delete(urlToDelete)
            }

            self.getFromRealmToArray()
        }
    }
}
