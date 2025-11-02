//
//  UIViewController+Navigate.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func navigate(to vc: UIViewController, coordinator: CoordinatorProtocol) {
        coordinator.eventOccurred(with: vc)
    }
}
