//
//  NavigatorError.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import Foundation

public enum NavigatorError: LocalizedError {
  /// No UINavigationController found in the current window.
  case noNavigationController
  /// No active key window found.
  case noWindow
  /// No view was found matching the given identifier.
  case viewNotFound(identifier: String)

  public var errorDescription: String? {
    switch self {
    case .noNavigationController:
      return "No navigation controller was found. Make sure your view is embedded in a NavigationStack."
    case .noWindow:
      return "No active window found. Ensure your app has a key window available."
    case .viewNotFound(let id):
      return "No view controller found with identifier '\(id)'."
    }
  }
}
