//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

enum WeatherEndpoint {
    case findCities(query: String)
    
    var path: String {
        switch self {
        case .findCities:
            return "find"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .findCities(let query):
            return [
                "q": query,
                "appid": NetworkConfig.apiKey,
                "units": "metric"
            ]
        }
    }
}
