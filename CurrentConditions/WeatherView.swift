//
//  ContentView.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI

struct WeatherView: View {
  
  @StateObject var viewModel = WeatherViewModel()
  
  var body: some View {
    ZStack {
      LinearGradient(gradient:Gradient(colors:[.blue, .gray]), startPoint:.top, endPoint:.trailing).edgesIgnoringSafeArea(.all)
      VStack {
        if viewModel.showWeather {
          HStack {
            Spacer()
            Toggle(viewModel._useCelsius ? "Switch to °F" : "Switch to °C", isOn: $viewModel._useCelsius)
              .toggleStyle(.button)
          }
          Text(viewModel.temperature)
            .font(Font.system(size: 56.0))
          Text(viewModel.locationName)
            .font(.system(size: 24.0))
          Text(viewModel.description)
        }
        else {
          Text("Weather App")
            .font(Font.system(size: 32.0))
        }
        Spacer()
      }
      .padding()
    }
    .foregroundColor(.white)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
