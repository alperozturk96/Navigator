//
//  NavigationError.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import Foundation

public enum NavigationError: LocalizedError {
  /// No UIScene found
  case noScene
  /// No view was found matching the given identifier.
  case viewNotFound(identifier: String)

  public var errorDescription: String? {
    switch self {
    case .noScene:
      return "No UIScene was found."
    case .viewNotFound(let id):
      return "No view controller found with identifier '\(id)'."
    }
  }
}
