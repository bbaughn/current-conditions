//
//  WeatherManager.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation
import CoreLocation
import Combine
import CoreLocation

class WeatherManager: NSObject, CLLocationManagerDelegate {
  static let shared = WeatherManager()
  
  let userDefaults = UserDefaults.standard
  let LOCATION_GEO = "locationGeo"
  let LOCATION_STRING = "locationString"
  
  // Location could be its own service
  let locationManager = CLLocationManager()
  
  @Published var apiFailure: Bool = false
  @Published var currentConditions: CurrentConditions? = nil
  
  internal var hasLocation: Published<Bool>.Publisher { $_hasLocation }
  @Published var _hasLocation: Bool = false
  
  internal var locationString: Published<String?>.Publisher { $_locationString }
  @Published var _locationString: String? = nil
  
  internal var locationGeo: Published<CLLocation?>.Publisher { $_locationGeo }
  @Published var _locationGeo: CLLocation? = nil
  
  internal var locationFailure: Published<Bool>.Publisher { $_locationFailure }
  @Published var _locationFailure: Bool = false
  
  override init() {
    super.init()
    // Should be broken out into a PersistenceService
    if let coordinates = userDefaults.object(forKey: LOCATION_GEO) as? [Double] {
      _locationGeo = CLLocation(latitude: coordinates[0], longitude: coordinates[1])
    }
    else {
      _locationGeo = nil
    }
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
          NetworkService.shared.getWeather(locationGeo)
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
  
  func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
      if let location = locations.last {
          _locationGeo = location
          userDefaults.set([location.coordinate.latitude, location.coordinate.longitude], forKey: LOCATION_GEO)
          userDefaults.removeObject(forKey: LOCATION_STRING)
          NetworkService.shared.getWeather(location)
      }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("Location manager did change authorization to \(locationManager.authorizationStatus)")
    if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
      locationManager.requestLocation()
    }
    else {
      _locationFailure = true
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed \(error.localizedDescription)")
    _locationFailure = true
  }
  
  func setGeo() {
    locationManager.delegate = self
    if locationManager.authorizationStatus == .notDetermined {
      locationManager.requestAlwaysAuthorization()
    }
    else {
      _locationGeo = nil
      locationManager.requestLocation()
    }
  }
  
  func setLocationString(_ inputString : String) {
    _locationString = inputString
  }
  
  func acknowledgeAPIFailure() {
    _locationString = nil
    _locationGeo = nil
    NetworkService.shared.acknowledgeAPIFailure()
  }
  
  func acknowledgeLocationFailure() {
    _locationString = nil
    _locationGeo = nil
    _locationFailure = false
  }
  
  func reset() {
    _locationGeo = nil
    _locationString = nil
    userDefaults.removeObject(forKey: LOCATION_GEO)
    userDefaults.removeObject(forKey: LOCATION_STRING)
    NetworkService.shared.resetCurrentConditions()
  }
}
