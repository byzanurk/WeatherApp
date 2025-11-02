//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

protocol MainViewModelProtocol {
    var delegate: MainViewModelOutput? { get set }
    var weatherList: [WeatherResponse] { get set }
    func searchCity(query: String)
}

protocol MainViewModelOutput: AnyObject {
    func didFetchWeather()
    func showError(message: String)
}

final class MainViewModel: MainViewModelProtocol {
    
    var weatherList: [WeatherResponse] = []
    weak var delegate: MainViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func searchCity(query: String) {
        service.searchCitys(query: query) { [weak self] result in
            switch result {
            case .success(let success):
                self?.weatherList = [success]
                self?.delegate?.didFetchWeather()
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
}
