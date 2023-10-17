//
//  Model.swift
//  TripPlanner
//
//  Created by user248619 on 10/16/23.
//

import Foundation

struct stockReuslts : Codable{
    var results: [StockValue]?
}

struct StockValue : Codable{
    var name : String
    var performanceId : String
}




