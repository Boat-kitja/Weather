//
//  CustomCell.swift
//  Weather
//
//  Created by Kitja  on 15/10/2565 BE.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    var weatherData:WeatherData!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabels: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(data:WeatherData) {
//        self.dateLabel.text = data.dt_txt
//        self.mainLabels.text = "\(data.main.temp) C"
    }
}
