//
//  FeedsTableViewController.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 26.06.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SDWebImage
import SafariServices

class ArticlesTableViewController: UITableViewController {
    var source: Source!
    var viewModel: ArticlesViewModelProtocol!
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var pullToRefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.update()
    }

    
    fileprivate func setupUI() {
        tableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.hidesWhenStopped = true
    }
    
    fileprivate func showIndicator() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.activityIndicator.isHidden = false
        pullToRefresh.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.addSubview(pullToRefresh)
    }
    
    fileprivate func hideIndicator() {
        self.navigationItem.rightBarButtonItem = nil
        pullToRefresh.endRefreshing()
    }
    
    @objc func update() {
        self.viewModel.updateItemsAction.apply((from: self.viewModel.items.count, batch: 10, source: self.source)).on(
            starting: {
                self.showIndicator()
        },
            terminated: {
                self.hideIndicator()
        },
            value: { items in
                self.viewModel.items.append(contentsOf: items)
                self.tableView.reloadData()
        }).start()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleItemTableViewCell.indetifier) as! ArticleItemTableViewCell
        cell.titleLabel.text = self.viewModel.items[indexPath.row].title
        cell.authorLabel.text = self.viewModel.items[indexPath.row].author
        cell.sourceLabel.text = self.source.name
        cell.descriptionLabel.text = self.viewModel.items[indexPath.row].descriptionText
        
        if let image = self.viewModel.items[indexPath.row].urlToImage {
            cell.urlToImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        } else {
            cell.urlToImageView.image = nil
        }

        if indexPath.row == self.viewModel.items.count - 1 && (indexPath.row + 1) % 10 == 0 {
            self.update()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: self.viewModel.items[indexPath.row].url) else { return }
        let sfVC = SFSafariViewController(url: url)
        self.navigationController?.pushViewController(sfVC, animated: true)
    }
}
