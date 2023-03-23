//
//  WeatherManager.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation
import CoreLocation
import Combine

class WeatherManager {
  static let shared = WeatherManager()
  
  let userDefaults = UserDefaults.standard
  let LOCATION_GEO = "locationGeo"
  let LOCATION_STRING = "locationString"
  
  @Published var apiFailure: Bool = false
  @Published var currentConditions: CurrentConditions? = nil
  
  internal var hasLocation: Published<Bool>.Publisher { $_hasLocation }
  @Published var _hasLocation: Bool = false
  
  internal var locationString: Published<String?>.Publisher { $_locationString }
  @Published var _locationString: String? = nil
  
  internal var locationGeo: Published<CLLocation?>.Publisher { $_locationGeo }
  @Published var _locationGeo: CLLocation? = nil
  
  init() {
    
    _locationString = userDefaults.object(forKey: LOCATION_STRING) as? String
    
    NetworkService.shared.currentConditions
      .receive(on:RunLoop.main)
      .assign(to: &$currentConditions)
    
    NetworkService.shared.apiFailure
      .receive(on:RunLoop.main)
      .assign(to: &$apiFailure)
    
    Publishers.CombineLatest($_locationGeo, $_locationString)
      .receive(on: RunLoop.main)
      .map { locationGeo, locationString -> Bool in
        if let locationGeo = self._locationGeo {
          return true
        }
        else if let locationString = self._locationString {
          self.userDefaults.set(locationString, forKey: self.LOCATION_STRING)
          self.userDefaults.removeObject(forKey: self.LOCATION_GEO)
          NetworkService.shared.getWeather(locationString)
          return true
        }
        return false
      }
      .assign(to: &$_hasLocation)
    
    
  }
  
  func setLocationString(_ inputString : String) {
    _locationString = inputString
  }
  
  func reset() {
    _locationGeo = nil
    _locationString = nil
    userDefaults.removeObject(forKey: LOCATION_GEO)
    userDefaults.removeObject(forKey: LOCATION_STRING)
    NetworkService.shared.resetCurrentConditions()
  }
}
