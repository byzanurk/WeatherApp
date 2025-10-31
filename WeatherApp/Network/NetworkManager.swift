//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        endpoint: WeatherEndpoint,
        responseType: T.Type,
        method: HTTPMethod,
        completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    func request<T: Decodable>(
        endpoint: WeatherEndpoint,
        responseType: T.Type,
        method: HTTPMethod,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard var components = URLComponents(string: NetworkConfig.baseURL + endpoint.path) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        components.queryItems = endpoint.parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        guard let url = components.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.unknown(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        task.resume()
        
    }
    
    
}
