//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelOutput? { get set }
    var weather: WeatherResponse? { get }
    var latitude: Double? { get }
    var longitude: Double? { get }
    var forecasts: [ForecastItem] { get set }
    func fetchForecast()
    func fetchWeatherByLocation()
}

protocol DetailViewModelOutput: AnyObject {
    func didFetchForecast()
    func showError(message: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    
    var delegate: DetailViewModelOutput?
    private let service: NetworkRouterProtocol
    var weather: WeatherResponse?
    var latitude: Double?
    var longitude: Double?
    var forecasts: [ForecastItem] = []
    
    init(service: NetworkRouterProtocol, weather: WeatherResponse? = nil) {
        self.service = service
        self.weather = weather
    }
    
    func fetchForecast() {
        service.fetchForecast(city: weather?.name ?? "") { [weak self] result in
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
    
    func fetchWeatherByLocation() {
        guard let lat = latitude,
              let lon = longitude else { return }
        service.fetchWeatherByLocation(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let success):
                self?.weather = success
                self?.fetchForecast()
                self?.delegate?.didFetchForecast()
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
}
