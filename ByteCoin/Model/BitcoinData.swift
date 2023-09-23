//
//  BitcoinData.swift
//  ByteCoin
//
//  Created by Cansu Aktas on 2023-09-23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct BitcoinData: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
