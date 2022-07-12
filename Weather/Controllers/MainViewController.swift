//
//  MainViewController.swift
//  Weather
//
//  Created by Вячеслав Терентьев on 12.07.2022.
//

import UIKit

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
        label.font = UIFont.systemFont(ofSize: 42)
        label.text = "15"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.text = "Kirishi"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(conditionImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
    }
}

extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            conditionImageView.heightAnchor.constraint(equalToConstant: 150),
            conditionImageView.widthAnchor.constraint(equalToConstant: 150),
            conditionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            conditionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
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
