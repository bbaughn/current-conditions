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
  @State private var showLocationModal: Bool = false
  @State private var showAPIFailureAlert: Bool = false
  @State private var showLocationFailureAlert: Bool = false

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
        else if showLocationFailureAlert {
          VStack {
            Text("Could not get location. You may have to enable it in Settings > Privacy > Location")
              .padding(20)
            Button("Ok") {
              WeatherManager.shared.acknowledgeLocationFailure()
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
      .onReceive(WeatherManager.shared.locationFailure, perform: { locationFailure in
        showLocationFailureAlert = locationFailure
      })
    }
  }

  func onDismiss() {}
}
