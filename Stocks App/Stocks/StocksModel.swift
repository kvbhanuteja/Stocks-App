//
//  StocksModel.swift
//  Stocks App
//
//  Created by bhanuteja on 15/12/21.
//

import Foundation

struct Stock: Decodable {
    let name: String
    let price: Float
    let percentage: String
}
