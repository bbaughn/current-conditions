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
          AsyncImage(url: viewModel.iconURL) { phase in
              switch phase {
                case .failure: Text("No Image")
                case .success(let image): image .resizable()
                default: ProgressView()
              }
            }
            .frame(width: 96, height: 96)
          Text(viewModel.description)
          HStack {
            Text("High:")
            Text(viewModel.temperatureHigh)
            Text(" Low:")
            Text(viewModel.temperatureLow)
          }
        }
        else {
          Text("Weather App")
            .font(Font.system(size: 32.0))
        }
        Spacer()
        Button(viewModel.showWeather ? "Reset Location" : "Set Location", action: { WeatherManager.shared.reset() })
        .frame(width: 280, height: 50)
        .foregroundColor(.blue)
        .background(content: { Color(.white) })
        .cornerRadius(8.0)
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
