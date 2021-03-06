//
//  MainViewController.swift
//  Weather
//
//  Created by Вячеслав Терентьев on 12.07.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    let backgroundView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let conditionImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud.rain")
        imageView.tintColor = UIColor(named: "weatherColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 62, weight: .bold)
        label.text = "15°C"
        label.textColor = UIColor(named: "weatherColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = UIColor(named: "weatherColor")
        label.text = "Kirishi"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "weatherColor")
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cityTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .systemGray4
        textField.clearButtonMode = .always
        textField.textColor = .black
        textField.returnKeyType = .go
        textField.borderStyle = .none
        textField.autocapitalizationType = .words
        textField.placeholder = "Search"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 15,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var geoLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "weatherColor")
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.addTarget(self, action: #selector(geoLocationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
        addTaps()
        setGeolocation()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(conditionImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(geoLocationButton)
    }
    
    private func setDelegates() {
        cityTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
    }
    
    private func setGeolocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func addTaps() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapScreen)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func searchButtonTapped() {
        cityTextField.endEditing(true)
        print(cityTextField.text!)
    }
    
    @objc private func geoLocationButtonTapped() {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        cityTextField.endEditing(true)
        print(cityTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = cityTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        cityTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate {
    
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)

        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            cityTextField.leadingAnchor.constraint(equalTo: geoLocationButton.trailingAnchor, constant: 10),
            cityTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            cityTextField.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            searchButton.heightAnchor.constraint(equalToConstant: 38),
            searchButton.widthAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            geoLocationButton.heightAnchor.constraint(equalToConstant: 38),
            geoLocationButton.widthAnchor.constraint(equalToConstant: 38),
            geoLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            geoLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            conditionImageView.heightAnchor.constraint(equalToConstant: 150),
            conditionImageView.widthAnchor.constraint(equalToConstant: 150),
            conditionImageView.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 30),
            conditionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: 10),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
}
