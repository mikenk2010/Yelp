//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    let latitude: Double?
    let longitude: Double?
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var latitude = 0.0
        var longitude = 0.0
        
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            var neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            
            latitude = (location!.valueForKeyPath("coordinate.latitude") as? Double)!
            longitude = (location!.valueForKeyPath("coordinate.longitude") as? Double)!
        }
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                var categoryName = category[0]
                categoryNames.append(categoryName)
            }
            self.categories = ", ".join(categoryNames)
        } else {
            self.categories = nil
        }
        
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            self.distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            self.distance = nil
        }
        
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    
    class func businesses(#array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            var business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: Float?, offset: Int?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, distance: distance, offset: offset, completion: completion)
    }
}
