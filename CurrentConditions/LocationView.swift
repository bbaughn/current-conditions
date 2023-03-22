//
//  LocationView.swift
//  CurrentConditions
//
//  Created by Brian Baughn on 3/22/23.
//

import SwiftUI
import UIKit

class LocationViewController: UIViewController {
  
  private static var locationInputDelegate = LocationInputDelegate()
  
  private var locationInputLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Enter a US City:"
      label.textAlignment = .left
      return label
  }()
  
  private var locationInput: TextField = {
    let input = TextField()
    input.placeholder = "Oakland, CA"
    input.clearsOnBeginEditing = true
    input.returnKeyType = .search
    input.backgroundColor = UIColor.white
    input.delegate = locationInputDelegate
    input.layer.cornerRadius = 4.0
    input.translatesAutoresizingMaskIntoConstraints = false
    return input
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.95, alpha: 1.0)
    
    view.addSubview(locationInput)
    NSLayoutConstraint.activate([
      locationInput.widthAnchor.constraint(equalToConstant: 280),
      locationInput.heightAnchor.constraint(equalToConstant: 50),
      locationInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      locationInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-100)
      ])

    view.addSubview(locationInputLabel)
    NSLayoutConstraint.activate([
      locationInputLabel.leadingAnchor.constraint(equalTo: locationInput.leadingAnchor),
      locationInputLabel.trailingAnchor.constraint(equalTo: locationInput.trailingAnchor),
      locationInputLabel.bottomAnchor.constraint(equalTo: locationInput.topAnchor),
      locationInputLabel.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private class LocationInputDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if let inputString = textField.text {
        textField.resignFirstResponder()
        WeatherManager.shared.setLocationString(inputString)
      }
      return true
    }
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

// Subclassing allows for inset
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 4
    @IBInspectable var insetY: CGFloat = 0
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
