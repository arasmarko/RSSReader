//
//  Feed.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import Foundation
import UIKit

class Feed {
    var name: String
    var image: UIImage?
    var stories: Set<Story>

    init(name: String, image: UIImage?, stories: Set<Story>) {
        self.name = name
        self.image = image
        self.stories = stories
    }
}
