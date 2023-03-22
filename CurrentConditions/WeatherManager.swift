//
//  WeatherManager.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation

class WeatherManager {
  static let shared = WeatherManager()
  
  func setLocationString(_ inputString : String) {
    print("In WeatherManager inputString is \(inputString)")
  }
  
}
