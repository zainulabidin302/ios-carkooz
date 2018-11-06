//
//  MyProductTableViewCell.swift
//  SideNavigation_Example
//
//  Created by apple on 11/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MyProductTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productBrandName: UILabel!
    @IBOutlet weak var productModel: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
