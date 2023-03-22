//
//  ContentView.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI

struct WeatherView: View {
  var body: some View {
    ZStack {
      LinearGradient(gradient:Gradient(colors:[.blue, .gray]), startPoint:.top, endPoint:.trailing).edgesIgnoringSafeArea(.all)
      VStack {
        Text("Weather App")
          .font(Font.system(size: 32.0))
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
