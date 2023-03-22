//
//  NetworkService.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation

class NetworkService {
  static let shared = NetworkService()
  
  let URL_API_KEY = "7a4fd9b9891b621814b0bca793977fb9"
  let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?"
  
  let session = URLSession(configuration: .default)
  
  internal var apiFailure: Published<Bool>.Publisher { $_apiFailure }
  @Published var _apiFailure: Bool = false
  
  func buildStringURL(_ string : String) -> String {
    let stringWithoutSpaces = string.replacingOccurrences(of: " ", with: "")
    let url = URL_BASE + "q=" + stringWithoutSpaces + ",US&appId=" + URL_API_KEY
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
            print(String(data: data, encoding: .utf8))
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
}
