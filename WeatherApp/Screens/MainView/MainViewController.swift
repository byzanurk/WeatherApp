//
//  ViewController.swift
//  WeatherApp
//
//  Created by Beyza Nur Tekerek on 31.10.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    var coordinator: CoordinatorProtocol!
    var viewModel: MainViewModelProtocol!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        viewModel.delegate = self
        setupTableView()
        setupUI()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
    }

    private func setupUI() {
        emptyStateView.isHidden = false
        searchBar.placeholder = "Find city..."
    }

}

// MARK: - TableView Delegate & DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        let weather = viewModel.weatherList[indexPath.row]
        cell.configure(with: weather)
        return cell
    }
}

// MARK: - SearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // debounce
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ query: String) {
        guard !query.isEmpty else { return }
        viewModel.searchCity(query: query)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchCity(query: query)
        searchBar.resignFirstResponder()
    }
}

// MARK: - MainViewModelOutput
extension MainViewController: MainViewModelOutput {
    func didFetchWeather() {
        DispatchQueue.main.async {
            self.emptyStateView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        debugPrint("Error:", message)
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
    }
}
