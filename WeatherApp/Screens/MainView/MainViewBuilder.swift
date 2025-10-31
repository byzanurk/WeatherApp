//
//  MainViewBuilder.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation
import UIKit

struct MainViewBuilder {
    static func build(coordinator: CoordinatorProtocol) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = MainViewModel(service: service)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let mainVC = storyboard.instantiateViewController(withIdentifier: "Main") as? MainViewController else {
            return UIViewController()
        }
        
        mainVC.viewModel = viewModel
        mainVC.coordinator = coordinator
        
        return mainVC
    }
}
