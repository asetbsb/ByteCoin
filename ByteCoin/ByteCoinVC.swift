//
//  ViewController.swift
//  ByteCoin
//
//  Created by Asset on 11/13/24.
//

import UIKit

final class ByteCoinVC: UIViewController {
    
    private var coinManager = CoinManager()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ByteCoin"
        label.font = UIFont.systemFont(ofSize: 50, weight: .thin)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Title Color")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tertiaryLabel.withAlphaComponent(0.3)
        view.layer.cornerRadius = 40
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        imageView.tintColor = UIColor(named: "Icon Color") ?? .white
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        coinManager.delegate = self
        view.backgroundColor = .systemTeal
        addSubviews()
        setConstraints()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(coinView)
        
        coinView.addSubview(coinImageView)
        coinView.addSubview(valueLabel)
        coinView.addSubview(currencyLabel)
        
        view.addSubview(currencyPicker)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            
            coinView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
            coinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coinView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            coinView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            
            coinImageView.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
            coinImageView.leadingAnchor.constraint(equalTo: coinView.leadingAnchor, constant: 10),
            coinImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            coinImageView.heightAnchor.constraint(equalTo: coinImageView.widthAnchor),
            
            valueLabel.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 30),
            
            currencyLabel.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
            currencyLabel.trailingAnchor.constraint(equalTo: coinView.trailingAnchor, constant: -10),
            
            currencyPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            currencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyPicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
}

extension ByteCoinVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        currencyLabel.text = selectedCurrency
    }
}

extension ByteCoinVC: CoinDataDelegate {
    func updateCurrencyPrice(_ currentPrice: Int) {
        DispatchQueue.main.async {
            self.valueLabel.text = String(currentPrice)
        }
    }
}
