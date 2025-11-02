//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 1.11.2025.
//

import UIKit
import MapKit
import Kingfisher

final class DetailViewController: UIViewController {

    var coordinator: CoordinatorProtocol!
    var viewModel: DetailViewModelProtocol!

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var rainLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var cloudLabel: UILabel!
    @IBOutlet private weak var sunriseLabel: UILabel!
    @IBOutlet private weak var sunsetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        fetchWeatherData()
        setupUI()
        setupCollectionView()
    }
    
    private func fetchWeatherData() {
        if viewModel.latitude != nil && viewModel.longitude != nil {
            viewModel.fetchWeatherByLocation()
        } else {
            viewModel.fetchForecast()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
    
    private func setupUI() {
        let weather = viewModel.weather
        cityNameLabel.text = weather?.name
        tempLabel.text = "\(Int(weather?.main?.temp ?? 0))°C"
        feelsLikeLabel.text = "Feels like: \(Int(weather?.main?.feelsLike ?? 0))°C"
        rainLabel.text = "☔️ Rain: \(String(format: "%.1f", weather?.rain?.oneHour ?? 0)) mm"
        humidityLabel.text = "💧 Humidity: \(weather?.main?.humidity ?? 0)%"
        speedLabel.text = "🌬 Wind: \(String(format: "%.1f", weather?.wind?.speed ?? 0)) m/s"
        cloudLabel.text = "☁️ Clouds: \(weather?.clouds?.all ?? 0)%"
        sunriseLabel.text = "🌅 Sunrise: \(formatTime(weather?.sys?.sunrise))"
        sunsetLabel.text = "🌇 Sunset: \(formatTime(weather?.sys?.sunset))"
        
        if let iconCode = weather?.weather?.first?.icon {
            let urlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
            if let url = URL(string: urlString) {
                iconImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "cloud.fill"),
                    options: [
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                iconImageView.image = UIImage(systemName: "questionmark.circle")
            }
        }
        iconImageView.layer.opacity = 0.6
        iconImageView.layer.zPosition = -1
    }
    
    private func formatTime(_ timestamp: Int?) -> String {
        guard let timestamp = timestamp else { return "--:--" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    
    @IBAction private func openMapButton(_ sender: Any) {
        let weather = viewModel.weather
        guard let lat = weather?.coord?.lat,
              let lon = weather?.coord?.lon else {
            debugPrint("Coordinates not available")
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let location = CLLocation(latitude: lat, longitude: lon)
        let mapItem = MKMapItem(location: location, address: nil)
        mapItem.name = weather?.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ])
    }
    
}

// MARK: - CollectionView Delegate & Datasource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        let item = viewModel.forecasts[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 110
        let height: CGFloat = 150
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewModelOutput {
    func didFetchForecast() {
        DispatchQueue.main.async {
            self.setupUI()
            self.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        debugPrint("error:", message)
    }
}
