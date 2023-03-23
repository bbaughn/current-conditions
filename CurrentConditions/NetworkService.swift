//
//  NetworkService.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation
import CoreLocation // Do away with this dependency when possible

// Could be in a models file
struct CurrentConditions: Codable {
  let weather: [Weather]
  let visibility: Int
  let name: String
  let main: Main
  let sys: Sys
}

struct Main: Codable {
  let temp: Double
  let feels_like: Double
  let temp_min: Double
  let temp_max: Double
}

struct Sys: Codable {
  let sunrise: Int
  let sunset: Int
}

struct Weather: Codable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}

class NetworkService {
  static let shared = NetworkService()
  
  let URL_API_KEY = "7a4fd9b9891b621814b0bca793977fb9"
  let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?"
  
  let session = URLSession(configuration: .default)
  
  internal var currentConditions: Published<CurrentConditions?>.Publisher { $_currentConditions }
  @Published var _currentConditions: CurrentConditions? = nil
  
  internal var apiFailure: Published<Bool>.Publisher { $_apiFailure }
  @Published var _apiFailure: Bool = false
  
  func buildStringURL(_ string : String) -> String {
    let stringWithoutSpaces = string.replacingOccurrences(of: " ", with: "")
    let url = URL_BASE + "q=" + stringWithoutSpaces + ",US&appId=" + URL_API_KEY
    print(url)
    return url
  }
  
  func buildGeoURL(_ geo : CLLocation) -> String {
    let url = URL_BASE + "lat=" + String(geo.coordinate.latitude) + "&lon=" + String(geo.coordinate.longitude) + "&appId=" + URL_API_KEY
    print(url)
    return url
  }
  
  func getWeather(_ string: String) {
    guard let url = URL(string: buildStringURL(string)) else {
      print("Error building string URL")
      return
    }
    getWeather(url: url)
  }
  
  func getWeather(_ geo: CLLocation) {
    guard let url = URL(string: buildGeoURL(geo)) else {
      print("Error building geo URL")
      return
    }
    getWeather(url: url)
  }
  
  private func getWeather(url: URL) {
    let task = session.dataTask(with: url) { (data, response, error) in
      
      DispatchQueue.main.async {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        guard let data = data, let response = response as? HTTPURLResponse else {
          self._apiFailure = true
          print("Invalid data or response")
          return
        }
        
        do {
          if response.statusCode == 200 {
            self._currentConditions = try JSONDecoder().decode(CurrentConditions.self, from: data)
          } else {
            print("Response wasn't 200. It was: " + "\n\(response.statusCode)")
            self._apiFailure = true
          }
        } catch {
          print(error.localizedDescription)
        }
      }
      
    }
    task.resume()
  }
  
  func acknowledgeAPIFailure() {
    _apiFailure = false
  }
  
  func resetCurrentConditions() {
    _currentConditions = nil
  }
}
