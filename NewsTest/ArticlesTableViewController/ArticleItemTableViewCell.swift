//
//  FeedItemTableViewCell.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 26.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit

class ArticleItemTableViewCell: UITableViewCell {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlToImageView: UIImageView!

    static let indetifier = "articleItemCell"
}
