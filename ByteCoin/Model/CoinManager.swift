//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFetchCoinPrice (_ coinManager: CoinManager, rate: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F19C1290-59A9-4775-BD10-08A5E14DDA93"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice (for currency: String) {
        
        //Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                //Format the data we got back as a string to be able to print it.
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        self.delegate?.didFetchCoinPrice(self, rate: bitcoinPrice)
                    }
                }
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    func parseJSON(_ coindata: Data) -> CoinModel? {
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: coindata)
            
            //Get the last property from the decoded data.

            let rate = decodedData.rate
            let currency = decodedData.asset_id_quote            
            let coin = CoinModel(rate: rate, currency: currency)
            return coin
        } catch {
             // Catch any errors
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
