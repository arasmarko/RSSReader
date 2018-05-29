//
//  StoryViewController.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import RealmSwift
import UIKit
import RxSwift
import SafariServices

class StoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let cellReuseIdentifier = "StoryTableViewCell"
    private var dataSource: [Story] = []
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 60
        let nib = UINib(nibName: "StoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        setupObservables()
    }

    func setStories(stories: List<Story>) {
        dataSource = stories.toArray()
        guard tableView != nil else { return }
        tableView.reloadData()
    }

    func setupObservables() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.presentSafariView(link: self.dataSource[indexPath.row].link)
            })
            .disposed(by: disposeBag)
    }

    private func presentSafariView(link: String) {
        if let url = URL(string: link) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let svc = SFSafariViewController(url: url, configuration: config)

            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        } else {
            print("WEBSITE ERROR :\(link)")
        }
    }
}

// Safari view
extension StoryViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
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
