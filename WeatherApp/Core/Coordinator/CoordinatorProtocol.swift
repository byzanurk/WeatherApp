//
//  CoordinatorProtocol.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var parentCoordinator: CoordinatorProtocol? { get set }
    var navigationController: UINavigationController? { get set }
    func eventOccurred(with viewController: UIViewController)
    func start()
}
