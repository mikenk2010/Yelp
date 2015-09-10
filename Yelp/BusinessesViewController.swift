//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    var searchActive: Bool = false
    var searchBarFilters: [Business]!
    
    var currentDeal: Bool!
    var currentDistance: Float!
    var currentSort: YelpSortMode!
    var currentCategories: [String]!
    var currentOffset: Int!
    
    var tempTableFooter: UIView!
    var loadingState: UIActivityIndicatorView!
    var noMoreResultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.searchBar.placeholder = "Restaurant"
        self.navigationItem.titleView = searchBar
        //self.searchBar.delegate = self
        
        
        Business.searchWithTerm("Restaurants", sort: currentSort, categories: currentCategories, deals: currentDeal, distance: currentDistance, offset: currentOffset) { (businesses: [Business]!, error: NSError!) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        /*
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        println(business.name!)
        println(business.address!)
        }
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Search Bar
    */
       func searchBarTextDidBeginEditing(searchBar: UISearchBar){}
    func searchBarTextDidEndEditing(searchBar: UISearchBar){}
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if businesses != nil {
            searchBarFilters = businesses!.filter({ (business) -> Bool in
                let tmpTitle = business.name
                let range = tmpTitle!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range != nil
            })
        }
        
        if (searchText == "" && searchBarFilters.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    func onFadedViewTap() {
        self.searchBar.endEditing(true)
    }
    
    
    /*
    // MARK: - Table view
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let businesses = businesses {
            if searchActive {
                return searchBarFilters!.count
            }
            return businesses.count
        } else {
            return 0
        }    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        var business = searchActive ? searchBarFilters : businesses!
        cell.business = business[indexPath.row]
        
        if indexPath.row == businesses.count - 1 {
            noMoreResultLabel.hidden ? self.loadingState.startAnimating() : loadingState.stopAnimating()
            searchMoreBusinesses()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchMoreBusinesses() {
        var moreBusinesses: [Business]!
        currentOffset = businesses.count
        Business.searchWithTerm("Restaurants", sort: currentSort, categories: currentCategories, deals: currentDeal, distance: currentDistance, offset: currentOffset) { (businesses: [Business]!, error: NSError!) -> Void in
            moreBusinesses = businesses
            if moreBusinesses.count == 0 {
                self.noMoreResultLabel.hidden = false
            } else {
                self.noMoreResultLabel.hidden = true
                for business in moreBusinesses {
                    self.businesses.append(business)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    func filtersViewController(filltersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        // Deals
        currentDeal = filters["deals"] as? Bool
        
        // Distance
        currentDistance = filters["distance"] as? Float
        
        // Sort
        var sortRawValue = filters["sortRawValue"] as? Int
        currentSort = (sortRawValue != nil) ? YelpSortMode(rawValue: sortRawValue!) : nil
        
        // Categories
        currentCategories = filters["categories"] as? [String]
        
        // Reset offset
        currentOffset = 0
        
        Business.searchWithTerm("Restaurants", sort: currentSort, categories: currentCategories, deals: currentDeal, distance: currentDistance, offset: currentOffset) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            if self.businesses.count == 0 {
                self.noMoreResultLabel.text = "Not found"
                self.noMoreResultLabel.hidden = false
            } else {
                self.noMoreResultLabel.text = "No more"
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
