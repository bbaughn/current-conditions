//
//  WeatherViewModel.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
  
  @Published var locationName: String = ""
  @Published var showWeather: Bool = false
  
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
  }
}
