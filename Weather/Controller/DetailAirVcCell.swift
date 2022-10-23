//
//  DetailAirVcCell.swift
//  Weather
//
//  Created by Kitja  on 22/10/2565 BE.
//

import UIKit

class DetailAirVcCell: UITableViewCell {

    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var airStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
