//
//  FeedItem.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 25.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation

struct Source {
    var id: String
    var name: String
    var description: String
}

struct Article {
    var author: String?
    var title: String
    var descriptionText: String?
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
}
