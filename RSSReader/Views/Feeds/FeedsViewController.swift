//
//  FeedsViewController.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FeedsViewController: UIViewController {
    private let viewModel: FeedsViewModelProtocol!
    private let tableView = UITableView()
    let cellReuseIdentifier = "FeedTableViewCell"
    let addFeedBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

    var dataSource: [Feed] = []

    private let disposeBag = DisposeBag()

    init(viewModel: FeedsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "RSS Feeds"
        setupTableView()
        render()
        setupObservables()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    private func setupTableView() {
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    }

    private func render() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        renderAddNewFeedButton()
    }

    private func renderAddNewFeedButton() {
        self.navigationItem.rightBarButtonItem = addFeedBarButton
    }

    private func setupObservables() {
        viewModel.feedItems
            .subscribe(onNext: { (feeds) in
                self.dataSource = feeds
                print("dataSource", self.dataSource.first?.title, self.dataSource.first?.stories.last?.title)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        addFeedBarButton.rx
            .tap
            .subscribe(onNext: { [weak self] (indexPath) in
                print("create")
                self?.askUserUrlForNewFeed()
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                let storyVC = StoryViewController(nibName: "StoryViewController", bundle: nil)
                storyVC.viewDidLoad() // TODO
                storyVC.setStories(stories: self.dataSource[indexPath.row].stories)
                self.navigationController?.pushViewController(storyVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func askUserUrlForNewFeed() {
        let alertController = UIAlertController(title: "New RSS Feed", message: "Please input URL for new feed", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            guard let `self` = self, let textField = alertController.textFields?.first else {
                    return
            }
            if let newUrl = textField.text {
                self.viewModel.newFeedUrlString.onNext(newUrl)
            }

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FeedsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(feedItem: dataSource[indexPath.row])
        return cell
    }
}

