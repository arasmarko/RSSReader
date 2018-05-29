//
//  FeedTableViewCell.swift
//  RSSReader
//
//  Created by Marko Aras on 22/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit
import SnapKit

class FeedTableViewCell: UITableViewCell {
    let feedImageView = UIImageView()
    let testLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(feedImageView)
        feedImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(120)
        }
        feedImageView.contentMode = .scaleAspectFit
        feedImageView.clipsToBounds = true

        self.addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(feedImageView.snp.right).offset(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(feedItem: Feed) {
        testLabel.text = feedItem.title
        if let urlString = feedItem.imageUrl, let url = URL(string: urlString) {
            feedImageView.downloadImage(url)
        }
    }
}

