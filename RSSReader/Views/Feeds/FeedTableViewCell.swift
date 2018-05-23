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
    let testLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(feedItem: Feed) {
        testLabel.text = feedItem.name
    }
}

