//
//  CurrencyViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 4/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class CurrencyController: UITableViewController, UISearchResultsUpdating{
    
    var fetchedCurrency = [Country]()
    
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    var filteredCurrencies = [Country]()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        retrieveData()
        
    }
    
    func retrieveData() {
        
        fetchedCurrency = []
        
        let url = Bundle.main.url(forResource: "Common-Currency", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            
            let currencies = json["Currencies"] as! [String: [String:Any]]
            let currencyCodes = currencies.keys.sorted()
            
            for code in currencyCodes {
                let currency = currencies[code]!
                let currencyName = currency["name"] as! String
                let currencySymbol = currency["symbol_native"] as! String
                
                self.fetchedCurrency.append(Country(currencyCode: code, currencyName: currencyName, currencySymbol: currencySymbol))
            }
        }
        catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredCurrencies = fetchedCurrency.filter({ (fetchedCurrency:Country) -> Bool in
            if (fetchedCurrency.currencyCode).contains((searchController.searchBar.text?.localizedUppercase)!) {
                return true
            }
            else {
                return false
            }
        })
        
        resultsController.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsController.tableView {
            return filteredCurrencies.count
        }else {
            return fetchedCurrency.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if tableView == resultsController.tableView {
            cell.textLabel?.text = "\(filteredCurrencies[indexPath.row].currencyCode) -  \(filteredCurrencies[indexPath.row].currencyName)"
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.2
            
            
        }else {
            cell.textLabel?.text = "\(fetchedCurrency[indexPath.row].currencyCode) -  \(fetchedCurrency[indexPath.row].currencyName)"
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.2
        }
        
        return cell
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if tableView == resultsController.tableView {
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyCode, forKey: "selectedCurrencyCode")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencySymbol, forKey: "selectedCurrencySymbol")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyName, forKey: "selectedCurrencyName")
            
        }else {
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyCode, forKey: "selectedCurrencyCode")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencySymbol, forKey: "selectedCurrencySymbol")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyName, forKey: "selectedCurrencyName")
        }
        
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }
    
}

class Country {
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    init(currencyCode:String, currencyName: String, currencySymbol: String){
        self.currencyName = currencyName
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
    }
    
}



