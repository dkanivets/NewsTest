//
//  SourcesViewModel.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 9/26/19.
//  Copyright © 2019 Dmitry Kanivets. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SourcesViewModelProtocol {
    var updateItemsAction: Action<Filter, [Source], NSError> { get }
    var items: [Source] { get set }
    var selectedSource: MutableProperty<Source?> { get set }
}

class SourcesViewModel: SourcesViewModelProtocol {
    lazy var updateItemsAction = NewsService.pullSourcesAction
    var items: [Source] = []
    var selectedSource: MutableProperty<Source?> = MutableProperty(nil)
}
