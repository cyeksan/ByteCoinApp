//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateExchangeRate(with bitcoin: BitcoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "MY_API_KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                }
                if let safeData = data {
                    if let bitcoin = parseJson(safeData) {
                        delegate?.didUpdateExchangeRate(with: bitcoin)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> BitcoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BitcoinData.self, from: data)
            let rate = String(format: "%.2f", decodedData.rate)
            let currency = decodedData.asset_id_quote
            let bitcoin = BitcoinModel(rate: rate, currency: currency)
            return bitcoin
        } catch {
            return nil
        }
    }
    
}
