//
//  DetailViewBuilder.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import Foundation
import UIKit

struct DetailViewBuilder {
    static func build(coordinator: CoordinatorProtocol, weather: WeatherResponse) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = DetailViewModel(service: service, weather: weather)
        let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else { return UIViewController() }
        
        detailVC.viewModel = viewModel
        detailVC.coordinator = coordinator
        
        return detailVC
    }
}
