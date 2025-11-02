//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "Failed to retrieve data."
        case .decodingError(let error):
            return "Data could not be parsed: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error. Status code: \(statusCode)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
