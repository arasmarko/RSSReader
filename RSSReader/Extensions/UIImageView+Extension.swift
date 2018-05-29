//
//  UIImageView+Extension.swift
//  RSSReader
//
//  Created by Marko Aras on 23/05/2018.
//  Copyright © 2018 arasmarko. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func downloadImage(_ URL: Foundation.URL) {
        self.kf.setImage(with: URL, placeholder: nil, options: [], progressBlock: nil)
    }
}
