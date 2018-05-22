//
//  Story.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import Foundation

class Story: Hashable {
    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    var hashValue: Int {
        return id
    }

    static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.id == rhs.id
    }
}
