//
//  ArticlesViewModel.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 26.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol ArticlesViewModelProtocol {
    var updateItemsAction: Action<(from: Int, batch: Int, source: Source), [Article], NSError> { get }
    var items: [Article] { get set }
    var selectedFeed: MutableProperty<Article?> { get set }
    var source: Source { get }
}

class ArticlesViewModel: ArticlesViewModelProtocol {
    lazy var updateItemsAction = NewsService.pullArticlesAction
    var items: [Article] = []
    var selectedFeed: MutableProperty<Article?> = MutableProperty(nil)
    var source: Source
    
    init(source: Source) {
        self.source = source
    }
}
