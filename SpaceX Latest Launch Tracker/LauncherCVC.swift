//
//  LauncherCVC.swift
//  SpaceX Latest Launch Tracker
//
//  Created by BerkH on 2.10.2023.
//

import UIKit

class LauncherCVC: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgPatch: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.masksToBounds = true
    }
    
}

