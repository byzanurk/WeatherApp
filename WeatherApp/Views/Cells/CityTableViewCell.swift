//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import UIKit
import Kingfisher

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with weather: WeatherResponse) {
        cityNameLabel.text = weather.name
        
        if let iconCode = weather.weather?.first?.icon {
            let urlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
            if let url = URL(string: urlString) {
                iconImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "cloud.fill"),
                    options: [
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                iconImageView.image = UIImage(systemName: "questionmark.circle")
            }
        }
     }
    
}

// "https://openweathermap.org/img/wn/10d@2x.png"
