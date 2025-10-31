//
//  NetworkRouter.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

protocol NetworkRouterProtocol {
    func searchCitys(query: String, completion: @escaping (Result<WeatherSearchResponse, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    private let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    func searchCitys(query: String, completion: @escaping (Result<WeatherSearchResponse, NetworkError>) -> Void) {
        let endpoint = WeatherEndpoint.findCities(query: query)
        
        service.request(
            endpoint: endpoint,
            responseType: WeatherSearchResponse.self,
            method: HTTPMethod.get,
            completion: completion
        )
    }
    
    
}
// https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
