//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelOutput? { get set }
    var weather: WeatherResponse { get }
    var forecasts: [ForecastItem] { get set }
    func fetchForecast()
}

protocol DetailViewModelOutput: AnyObject {
    func didFetchForecast()
    func showError(message: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    
    var delegate: DetailViewModelOutput?
    private let service: NetworkRouterProtocol
    let weather: WeatherResponse
    var forecasts: [ForecastItem] = []
    
    init(service: NetworkRouterProtocol, weather: WeatherResponse) {
        self.service = service
        self.weather = weather
    }
    
    func fetchForecast() {
        service.fetchForecast(city: weather.name ?? "") { [weak self] result in
            switch result {
            case .success(let success):
                let filtered = success.list.filter { item in
                    let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    return formatter.string(from: date) == "12"
                }
                self?.forecasts = filtered
                self?.delegate?.didFetchForecast()
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
}
