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
    
    static var pullArticlesAction: Action<[String : AnyObject], [Article], NSError> = Action {
        return NewsService.pullArticles($0)
    }
    
    static func pullArticles(_ parameters: [String : AnyObject]) -> SignalProducer<[Article], NSError> {
        return NetworkService.everything.jsonSignalProducer(parameters)
        .flatMap(.concat, {json -> SignalProducer<[Article], NSError> in
            guard let itemsArray = json["articles"].array, let articles = itemsArray.failableMap({$0.jsonToArticle()}) else {
                return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
            }
            
            return SignalProducer(value: articles)
        })
    }
    
    static func pullSources(_ parameters: [String : AnyObject]) -> SignalProducer<[Source], NSError> {
        return NetworkService.sources.jsonSignalProducer(parameters)
        .flatMap(.concat, {json -> SignalProducer<[Article], NSError> in
            guard let itemsArray = json["sources"].array, let sources = itemsArray.failableMap({$0.jsonToSource()}) else {
                return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
            }
            
            return SignalProducer(value: articles)
        })
    }
    
}

private extension JSON {
    
    func jsonToArticle() -> Article? {
        guard let title = self["title"].string,
            let url = self["url"].string,
            let urlToImage = self["urlToImage"].string,
            let publishedAt = self["publishedAt"].string,
            let content = self["content"].string

            else { return nil }
        return Article(author: self["author"].string, title: title, descriptionText: self["description"].string, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
    }

    func jsonToSource() -> Source? {
           guard let id = self["id"].string,
               let name = self["name"].string,
               let descriptionText = self["description"].string,
               let publishedAt = self["publishedAt"].string,
               let content = self["content"].string

               else { return nil }
           return Article(author: self["author"].string, title: title, descriptionText: self["description"].string, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
       }
}
