//
//  NewsService.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 25.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON

struct NewsService {
    
    static var pullArticlesAction: Action<(from: Int, batch: Int, source: Source), [Article], NSError> = Action {
        return NewsService.pullArticles(from: $0.from, batch: $0.batch, source: $0.source)
    }
    
    static func pullArticles(from: Int, batch: Int, source: Source) -> SignalProducer<[Article], NSError> {
        return NetworkService.everything.jsonSignalProducer(["page" : (from / 10 > 0 ? from / 10 : 1) as AnyObject, "pageSize" : batch as AnyObject, "sources" : source.id as AnyObject])
            .flatMap(.concat, {json -> SignalProducer<[Article], NSError> in
                guard let itemsArray = json["articles"].array, let articles = itemsArray.failableMap({$0.jsonToArticle()}) else {
                    return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
                }
                
                return SignalProducer(value: articles)
            })
    }
    
    static var pullSourcesAction: Action<Filter, [Source], NSError> = Action {
        return NewsService.pullSources($0)
    }
    
    static func pullSources(_ filter: Filter) -> SignalProducer<[Source], NSError> {
        return NetworkService.sources.jsonSignalProducer(["category" : filter.category.rawValue as AnyObject, "language" : filter.language.rawValue as AnyObject, "country" : filter.country.rawValue as AnyObject])
            .flatMap(.concat, {json -> SignalProducer<[Source], NSError> in
                guard let itemsArray = json["sources"].array, let sources = itemsArray.failableMap({$0.jsonToSource()}) else {
                    return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
                }
                
                return SignalProducer(value: sources)
            })
    }
    
}

private extension JSON {
    
    func jsonToArticle() -> Article? {
        guard let title = self["title"].string,
            let url = self["url"].string,
            let publishedAt = self["publishedAt"].string,
            let content = self["content"].string
            
            else { return nil }
        return Article(author: self["author"].string, title: title, descriptionText: self["description"].string, url: url, urlToImage: self["urlToImage"].string, publishedAt: publishedAt, content: content)
    }
    
    
    func jsonToSource() -> Source? {
        guard let id = self["id"].string,
            let name = self["name"].string,
            let descriptionText = self["description"].string,
            let url = self["url"].string,
            let language = self["language"].string,
            let country = self["country"].string,
            let category = self["category"].string
            
            else { return nil }
        
        return Source(id: id, name: name, descriptionText: descriptionText, url: url, category: category, language: language, country: country)
    }
}
