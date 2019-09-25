//
//  FeedItemDetailViewController.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 6/26/18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit

class FeedItemDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    fileprivate func setupUI() {
        textView.text = article?.content
        title = article?.title
    }
}
