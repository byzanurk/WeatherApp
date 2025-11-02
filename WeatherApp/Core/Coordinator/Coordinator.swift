//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation
import UIKit

final class Coordinator: CoordinatorProtocol {
    
    var parentCoordinator: CoordinatorProtocol?
    var navigationController: UINavigationController?

    func eventOccurred(with viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func start() {
        let vc = MainViewBuilder.build(coordinator: self)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    
}
