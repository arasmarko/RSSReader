//
//  StoryTableViewCell.swift
//  RSSReader
//
//  Created by Marko Aras on 27/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(story: Story) {
        titleLabel.text = story.title
        if let link = story.imageUrl, let url = URL(string: link) {
            storyImageView.downloadImage(url)
        }
    }
}
