//
//  BusinessCell.swift
//  Yelp
//
//  Created by Bao Nguyen on 9/3/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var catagoriesLabel: UILabel!
    
    var business: Business!{
        didSet{
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            thumbImageView.setImageWithURL(business.imageURL)
            reviewsCountLabel.text = "\(business.reviewCount) Reviews"
            addressLabel.text = business.address
            catagoriesLabel.text = business.categories
            ratingImageView.setImageWithURL(business.ratingImageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
