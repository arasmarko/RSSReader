//
//  StoryViewController.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift
import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var testL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    func setStories(stories: List<Story>) {
        testL.text = "\(stories.count)"
    }
}
