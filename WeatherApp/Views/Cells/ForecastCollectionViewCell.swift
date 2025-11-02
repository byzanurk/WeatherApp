//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import UIKit
import Kingfisher

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func configure(with item: ForecastItem) {
        tempLabel.text = "\(Int(item.main.temp ?? 0))°C"
        
        if let icon = item.weather.first?.icon {
            let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
            iconImageView.kf.setImage(with: url)
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        dateLabel.text = formatter.string(from: date)

    }
    
    
}
