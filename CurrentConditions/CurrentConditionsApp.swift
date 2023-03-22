//
//  CurrentConditionsApp.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI

@main
struct CurrentConditionsApp: App {
  
    @State private var showLocationModal: Bool = true
  
    var body: some Scene {
        WindowGroup {
            WeatherView()
            .sheet(isPresented: $showLocationModal, onDismiss: onDismiss, content: { LocationView() })
        }
    }
  
    func onDismiss() {}
}
