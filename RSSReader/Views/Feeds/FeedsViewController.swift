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
            .subscribe(onNext: { (res) in
                self.dataSource = res
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        addFeedBarButton.rx
            .tap
            .subscribe(onNext: { [weak self] (indexPath) in
                print("create")
//                let storyVC = StoryViewController()
//                self?.navigationController?.pushViewController(storyVC, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                let storyVC = StoryViewController()
                self?.navigationController?.pushViewController(storyVC, animated: true)
            })
            .disposed(by: disposeBag)

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

