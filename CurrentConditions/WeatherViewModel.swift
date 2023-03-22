//
//  WeatherViewModel.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
  
  @Published var showWeather: Bool = false
  @Published var locationName: String = ""
  @Published var temperature: String = ""
  @Published var temperatureHigh: String = ""
  @Published var temperatureLow: String = ""
  @Published var description: String = ""
  @Published var iconURL: URL? = nil
  
  var useCelsius: Published<Bool>.Publisher { $_useCelsius }
  @Published var _useCelsius: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    WeatherManager.shared.$currentConditions
      .receive(on: RunLoop.main)
      .sink { currentConditions in
        guard let currentConditions = currentConditions else {
          self.showWeather = false
          return
        }
        self.showWeather = true
        self.locationName = currentConditions.name
        
      }.store(in: &self.cancellables)
    
    Publishers.CombineLatest(NetworkService.shared.currentConditions, useCelsius)
    .receive(on: RunLoop.main)
    .sink { currentConditions, temperatureUnits in
      guard let currentConditions = currentConditions else { return }
      let units : UnitTemperature = self._useCelsius ? .celsius : .fahrenheit
      self.temperature = self.convertTemperature(temp: currentConditions.main.temp, from: .kelvin, to: units)
      self.temperatureHigh = self.convertTemperature(temp: currentConditions.main.temp_max, from: .kelvin, to: units)
      self.temperatureLow = self.convertTemperature(temp: currentConditions.main.temp_min, from: .kelvin, to: units)
      self.iconURL = URL(string: "https://openweathermap.org/img/wn/" + currentConditions.weather[0].icon + "@2x.png")
      self.description = currentConditions.weather[0].main
    }.store(in: &self.cancellables)
  }
  
  // Could be in a utilities file
  func convertTemperature(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
      let measurementFormatter = MeasurementFormatter()
      measurementFormatter.numberFormatter.maximumFractionDigits = 0
      measurementFormatter.unitOptions = .providedUnit
      let input = Measurement(value: temp, unit: inputTempType)
      let output = input.converted(to: outputTempType)
      return measurementFormatter.string(from: output)
    }
}
