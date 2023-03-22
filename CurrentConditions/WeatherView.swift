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
          Text(viewModel.locationName)
            .font(.system(size: 24.0))
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
