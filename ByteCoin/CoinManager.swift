//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Asset on 11/13/24.
//

import Foundation

protocol CoinDataDelegate {
    func updateCurrencyPrice (_ currentPrice: Int)
}

struct CoinManager {
    
    var delegate: CoinDataDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A68FE076-5DF3-4C12-AB0F-113F26B4ACF5"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    if let resultData = parseJSON(safeData) {
                        delegate?.updateCurrencyPrice(resultData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Int? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            
            return Int(lastPrice)
        } catch {
            return nil
        }
    }
}
