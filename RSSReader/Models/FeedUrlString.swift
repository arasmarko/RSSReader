//
//  FeedUrlString.swift
//  RSSReader
//
//  Created by Marko Aras on 27/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift

class FeedUrlString: Object {
    @objc dynamic var urlString: String = ""

    convenience init(_ string: String) {
        self.init()
        self.urlString = string
    }
}
