//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather(query: String)
    case forecast(query: String)
    
    var path: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .currentWeather(let query),
             .forecast(query: let query):
            return [
                "q": query,
                "appid": NetworkConfig.apiKey,
                "units": "metric"
            ]
        }
    }
}
