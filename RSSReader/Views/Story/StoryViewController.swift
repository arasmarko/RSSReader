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

    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "StoryTableViewCell"
    var dataSource: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tableView.dataSource = self
        tableView.rowHeight = 60
        let nib = UINib(nibName: "StoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }

    func setStories(stories: List<Story>) {
        print("Stories1", dataSource.count)
        dataSource = Array(stories.toArray())
        print("Stories2", dataSource.count)
        tableView.reloadData()
    }
}

extension StoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? StoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(story: dataSource[indexPath.row])
        return cell
    }
}
