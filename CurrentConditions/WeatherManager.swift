//
//  WeatherManager.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation

class WeatherManager {
  static let shared = WeatherManager()
  
  @Published var apiFailure: Bool = false
  @Published var currentConditions: CurrentConditions? = nil
  
  internal var locationString: Published<String?>.Publisher { $_locationString }
  @Published var _locationString: String? = nil
  
  init() {
    NetworkService.shared.currentConditions
      .receive(on:RunLoop.main)
      .assign(to: &$currentConditions)
    
    NetworkService.shared.apiFailure
      .receive(on:RunLoop.main)
      .assign(to: &$apiFailure)
  }
  
  func setLocationString(_ inputString : String) {
    _locationString = inputString
    if let _locationString = _locationString {
      NetworkService.shared.getWeather(_locationString)
    }
  }
  
}
