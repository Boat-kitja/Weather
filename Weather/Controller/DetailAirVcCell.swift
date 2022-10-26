//
//  DetailAirVcCell.swift
//  Weather
//
//  Created by Kitja  on 22/10/2565 BE.
//

import UIKit

class DetailAirVcCell: UITableViewCell {

   
    @IBOutlet weak var airStatusLabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var airDetailLabel: UILabel!
    
    @IBOutlet weak var meter: GradientSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
