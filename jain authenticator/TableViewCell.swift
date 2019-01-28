//
//  TableViewCell.swift
//  jain authenticator
//
//  Created by Shubham Jain on 30/07/18.
//  Copyright © 2018 Shubham Jain. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var otpViewOutlet: UIView!
    @IBOutlet var nameOutlet: UILabel!
    
    @IBOutlet var propgressBarOutlet: ProgressBarView!
    @IBOutlet var otpCodeOutlet: UILabel!
    
    @IBOutlet var mailIdOutlet: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
//    override func reloadInputViews() {
//        view.reloadInputViews()
//    }

    func configure(isEmpty: Bool,_ otpData : otpData) {
//        setupImage(isEmpty)
        if !isEmpty {
              nameOutlet.text = otpData.name
              otpCodeOutlet.text = otpData.otpCode
              mailIdOutlet.text = otpData.emailId
        }
        else {
            nameOutlet.text = ""
            otpCodeOutlet.text = ""
            mailIdOutlet.text = ""
        }
        
    }
//    func setupImage(_ isEmpty: Bool)
//    {
//        bankImage.clipsToBounds = true
//        view.layer.cornerRadius = (view.layer.bounds.width) / 2
//        bankImage.layer.cornerRadius = (bankImage.layer.bounds.width) / 2
//        if !isEmpty {
//            view.layer.shadowColor = UIColor.black.cgColor
//            view.layer.shadowOpacity = 0.5
//            view.layer.shadowOffset = CGSize(width: 1, height: 1)
//            view.layer.shadowRadius = 0.5
//        }
//    }
}

class TableImageViewCell: UITableViewCell{
    
    
    
}
