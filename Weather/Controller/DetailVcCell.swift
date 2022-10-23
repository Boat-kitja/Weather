//
//  DetailVCCell.swift
//  Weather
//
//  Created by Kitja  on 18/10/2565 BE.
//

import UIKit

class DetailVcCell: UITableViewCell {
    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var htempLabel: UILabel!
    @IBOutlet weak var ltempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
