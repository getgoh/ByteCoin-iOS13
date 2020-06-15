//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFetchRate(rate: Double, currency: String)
    func didFail(with error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B884083F-DA15-49B5-8750-FBAAC804EC7C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        fetchURL(with: urlString, currency: currency)
    }
    
    func fetchURL(with urlString: String, currency: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let coinData = self.parseJSON(safeData) {
                        self.delegate?.didFetchRate(rate: coinData.rate, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let coinData = try decoder.decode(CoinData.self, from: data)
            return coinData
        } catch {
            delegate?.didFail(with: error)
            return nil
        }
    }
    
}
