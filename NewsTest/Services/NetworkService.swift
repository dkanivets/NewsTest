//
//  NetworkService.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 10.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import Result
import SwiftyJSON

enum NetworkService {
    private static let baseURL = "https://newsapi.org/v2/"
    private static let apiKey = "cd08374673b84437a04479d3fc2e4390"
    case
    topHeadlines,
    everything,
    sources
    
    var path : (Alamofire.HTTPMethod, String) {
        switch self {
        case .topHeadlines: return (.get, "top-headlines")
        case .everything:   return (.get, "everything")
        case .sources:      return (.get, "sources")
        }
    }
    
    fileprivate func dataSignalProducer(_ parameters:[String : AnyObject] = [String: AnyObject]()) -> SignalProducer<(response: HTTPURLResponse, data: Data), NSError> {
            let (responseProducerSignal, observerResponse) = SignalProducer<(response: HTTPURLResponse, data: Data), NSError>.ProducedSignal.pipe()
            let responseProducer = SignalProducer(responseProducerSignal)
        var finalParameters = parameters
        finalParameters["apiKey"] = NetworkService.apiKey as AnyObject
        let alamofireRequest = Alamofire.request(NetworkService.baseURL + self.path.1, method: self.path.0, parameters: finalParameters)
            
            alamofireRequest.responseString { response in
                print("REQUEST: \(response.request.debugDescription)")
                print("RESPONSE: \(response.result.debugDescription)")
                DispatchQueue.main.async {
                    if response.response?.statusCode != 200 {
                        observerResponse.send(error: NSError(domain: "Error 200", code: 200, userInfo: nil))
                    } else if let alamofireError = response.result.error {
                        observerResponse.send(error: alamofireError as NSError)
                    } else if let data = response.data, let res = response.response {
                        observerResponse.send(value: (response: res, data: data))
                        observerResponse.sendCompleted()
                    }
                }
            }
            
            return responseProducer
    }
    
    func jsonSignalProducer(_ parameters:[String : AnyObject] = [String: AnyObject]()) -> SignalProducer<JSON, NSError> {
        return self.dataSignalProducer(parameters)
            .flatMap(FlattenStrategy.merge) { (response: HTTPURLResponse, data: Data) in
                return self.serializedJsonProducer(data, encoding: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((response.textEncodingName ?? "utf-8") as CFString)))
            }
            .on (failed: {
                print("---ERROR---\n\($0)\n-----------")
            }
        )
    }
    
    fileprivate func serializedJsonProducer(_ data: Data, encoding: UInt) -> SignalProducer<JSON, NSError> {
        return SignalProducer { observer, _ in
            do {
                let nsJson: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                observer.send(value: JSON(nsJson))
                observer.sendCompleted()
            } catch _ {
                print("Respose cant be parsed")
            }
        }
    }
}
