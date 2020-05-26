//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Arturo Polanco on 5/25/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let currency: String
    
    var coinPriceString: String {
        return String(format: "%.2f", rate)
    }
}
