//
//  FiltersViewController.swift
//  NewsTest
//
//  Created by Dmitry Kanivets on 9/26/19.
//  Copyright © 2019 Dmitry Kanivets. All rights reserved.
//

import UIKit

enum Category: String, CaseIterable {
    case all = "", business = "business", entertainment = "entertainment", general = "general", health = "health", science = "science", sports = "sports", technology = "technology"
}

enum Language: String, CaseIterable {
    case all = "", ar = "ar", de = "de", en = "en", es = "es", fr = "fr", he = "he", it = "it", nl = "nl", no = "no", pt = "pt", ru = "ru", se = "se", ud = "ud", zh = "zh"
}

enum Country: String, CaseIterable {
    case all = "", us = "us", ae = "ae", ar = "ar", at = "at", au = "au", be = "be", bg = "bg", br = "br", ca = "ca", ch = "ch", cn = "cn", co = "co", cu = "cu", cz = "cz", de = "de", eg = "eg", fr = "fr", gb = "gb", gr = "gr", hk = "hk", hu = "hu", id = "id", ie = "ie", il = "il", it = "it", jp = "jp", kr = "kr", lt = "lt", ua = "ua", ru = "ru"
}

struct Filter {
    var category: Category
    var language: Language
    var country: Country
}

class FiltersViewController: UITableViewController {
    
    var categories: [Category] = Category.allCases
    var languages: [Language] = Language.allCases
    var countries: [Country] = Country.allCases
    
    var selectedCategory: Category = .all
    var selectedLanguage: Language = .all
    var selectedCountry: Country = .all
    
    var completionHandler: ((Filter) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(apply))
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func apply() {
        if let completion = completionHandler {
            completion(Filter(category: selectedCategory, language: selectedLanguage, country: selectedCountry))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "filterCell")
        
        cell.textLabel?.text = {
            switch indexPath.section {
            case 0:
                let category = categories[indexPath.row]
                cell.accessoryType = category == selectedCategory ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
                return category.rawValue
            case 1:
                
                let language = languages[indexPath.row]
                cell.accessoryType = language == selectedLanguage ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
                return language.rawValue
            case 2:
                
                let country = countries[indexPath.row]
                cell.accessoryType = country == selectedCountry ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
                return country.rawValue
            default:
                return ""
            }
        }()
        if cell.textLabel?.text == "" {
            cell.textLabel?.text = "Any"
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categories.count
        case 1:
            return languages.count
        case 2:
            return countries.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Categories".uppercased()
        case 1:
            return "Languages".uppercased()
        case 2:
            return "Countries".uppercased()
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        switch indexPath.section {
        case 0:
            selectedCategory = categories[indexPath.row]
        case 1:
            selectedLanguage = languages[indexPath.row]
        case 2:
            selectedCountry = countries[indexPath.row]
        default:
            ()
        }
        
        tableView.reloadData()
    }
}
