//
//  WeatherManager.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation

class WeatherManager {
  static let shared = WeatherManager()
  
  internal var locationString: Published<String?>.Publisher { $_locationString }
  @Published var _locationString: String? = nil
  
  func setLocationString(_ inputString : String) {
    _locationString = inputString
    if let _locationString = _locationString {
      NetworkService.shared.getWeather(_locationString)
    }
  }
  
}
