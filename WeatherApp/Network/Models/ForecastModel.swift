//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
