//
//  CurrentConditionsApp.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI

@main
struct CurrentConditionsApp: App {
    
  // These could be in a view model
  @State private var showLocationModal: Bool = true
  @State private var showAPIFailureAlert: Bool = false

  var body: some Scene {
    WindowGroup {
      ZStack {
        if showAPIFailureAlert {
          VStack {
            Text("Could not get weather for this location")
            Button("Ok") {
              WeatherManager.shared.acknowledgeAPIFailure()
            }
          }
        }
        else {
          WeatherView()
            .sheet(isPresented: $showLocationModal, onDismiss: onDismiss, content: { LocationView() })
            .onReceive(WeatherManager.shared.hasLocation) { hasLocation in
              showLocationModal = !hasLocation
            }
            
        }
      }
      .onReceive(WeatherManager.shared.$apiFailure, perform: { apiFailure in
        showAPIFailureAlert = apiFailure
      })
    }
  }

  func onDismiss() {}
}
