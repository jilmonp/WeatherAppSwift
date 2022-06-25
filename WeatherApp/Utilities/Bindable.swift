//
//  Bindable.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import Foundation

// Bindable is initialized with the value we want to observe.
// Bind does the binding and gets the value.
// listener is the closure called when the value is set.

final class Bindable<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  var value: T {
    didSet {
      listener?(value)
    }
  }
  init(_ value: T) {
    self.value = value
  }
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
