//
//  MyCarsTableViewCell.swift
//  SideNavigation_Example
//
//  Created by apple on 11/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MyCarsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet var iconsViewCollection: [UIView]!
    
    @IBOutlet weak var ratting: UILabel!
    @IBOutlet weak var verificationTopLabel: UILabel!
    @IBOutlet weak var verficationMidLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var color: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var imageViewContainer: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        imageViewContainer.layer.borderColor = UIColor.lightGray.cgColor
       
        iconsViewCollection.forEach { (item) in
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
