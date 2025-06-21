//
//  NavigatorError.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import Foundation

public enum NavigatorError: Error {
    case noNavigationController
    case noWindow
    case viewNotFound(identifier: String)
}

extension NavigatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNavigationController:
            return "No navigation controller was found. Ensure you're calling this from a view embedded in a navigation stack."
        case .noWindow:
            return "No window is currently active. Make sure your application has a key window available."
        case .viewNotFound(let identifier):
            return "No view controller found with the identifier '\(identifier)'."
        }
    }
}
