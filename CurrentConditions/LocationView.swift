//
//  LocationView.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI
import UIKit

class LocationViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.95, alpha: 1.0)
  }
  
}

struct LocationViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewController {
      let locationViewController = LocationViewController()
      return locationViewController
  }
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct LocationView: View {
  typealias UIViewControllerType = LocationViewController
  var body: some View {
    LocationViewControllerWrapper().ignoresSafeArea()
  }
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
      LocationView()
  }
}
