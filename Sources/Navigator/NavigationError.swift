//
//  NavigatorError.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import Foundation

/// Errors thrown by `Navigator` if it cannot find a window or navigation stack.
public enum NavigationError: LocalizedError {
  /// No UINavigationController found in the current window.
  case noNavigationController
  /// No active key window found.
  case noWindow
  /// No view was found matching the given identifier.
  case viewNotFound(identifier: String)

  public var errorDescription: String? {
    switch self {
    case .noNavigationController:
      return "No navigation controller was found. Make sure your view is embedded in a Navigation Stack."
    case .noWindow:
      return "No active window found. Ensure your app has a key window available."
    case .viewNotFound(let id):
      return "No view controller found with identifier '\(id)'."
    }
  }
}
