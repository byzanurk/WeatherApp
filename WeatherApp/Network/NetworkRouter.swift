//
//  NetworkRouter.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

protocol NetworkRouterProtocol {
    func searchCitys(query: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
    func fetchForecast(city: String, completion: @escaping (Result<ForecastResponse, NetworkError>) -> Void)
    func fetchWeatherByLocation(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    private let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    func searchCitys(query: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let endpoint = WeatherEndpoint.currentWeather(query: query)
        
        service.request(
            endpoint: endpoint,
            responseType: WeatherResponse.self,
            method: HTTPMethod.get,
            completion: completion
        )
    }
    
    func fetchForecast(city: String, completion: @escaping (Result<ForecastResponse, NetworkError>) -> Void) {
        let endpoint = WeatherEndpoint.forecast(query: city)
        
        service.request(
            endpoint: endpoint,
            responseType: ForecastResponse.self,
            method: .get,
            completion: completion
        )
    }
    
    func fetchWeatherByLocation(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let endpoint = WeatherEndpoint.currentWeatherByCoord(lat: lat, lon: lon)
        
        service.request(
            endpoint: endpoint,
            responseType: WeatherResponse.self,
            method: .get,
            completion: completion
        )
    }
}
