//
//  ViewController.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 6/25/18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class SourcesViewController: UITableViewController {
    private var viewModel: SourcesViewModelProtocol = SourcesViewModel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var filter = Filter(category: .all, language: .all, country: .all)
    private var pullToRefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.update(filter: filter)
    }

    @IBAction func showFilters(sender: UIBarButtonItem) {
        let filtersVC = FiltersViewController()
        filtersVC.completionHandler = { [weak self] filter in
            if let `self` = self {
                self.filter = filter
                self.update(filter: filter)
            }
        }
        
        filtersVC.selectedCategory = filter.category
        filtersVC.selectedLanguage = filter.language
        filtersVC.selectedCountry = filter.country

        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    fileprivate func setupUI() {
        tableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.hidesWhenStopped = true
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(pullToRefresh)
    }
    
    fileprivate func showIndicator() {
        self.navigationItem.titleView = activityIndicator
        self.activityIndicator.isHidden = false
    }
    
    fileprivate func hideIndicator() {
        self.navigationItem.titleView = nil
        pullToRefresh.endRefreshing()
    }
    
    @objc func refresh() {
        self.update(filter: filter)
    }
    
    fileprivate func update(filter: Filter) {
        self.viewModel.updateItemsAction.apply(filter).on(
            starting: {
                self.showIndicator()
        },
            terminated: {
                self.hideIndicator()
        },
            value: { items in
                self.viewModel.items = items
                self.tableView.reloadData()
        }).start()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "sourceCell")
        cell.textLabel?.text = self.viewModel.items[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.viewModel.selectedSource.value = self.viewModel.items[indexPath.row]
        self.performSegue(withIdentifier: "showArticles", sender: indexPath);
    }
    
    // MARK: - UIStoryboardSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ArticlesTableViewController, let indexPath = sender as? IndexPath, (segue.identifier == "showArticles") {
            controller.source = self.viewModel.items[indexPath.row]
            controller.viewModel = ArticlesViewModel(source: controller.source)
        }
    }
}

