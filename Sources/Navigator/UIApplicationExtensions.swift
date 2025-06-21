//
//  UIApplicationExtensions.swift
//
//
//  Created by Alper Ozturk on 19.5.23..
//

import UIKit
import SwiftUI

// MARK: - UIWindow
extension UIApplication {
    var firstWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0.windows.first(where: \.isKeyWindow) }
            .first
    }
}


// MARK: - Navigation Controller
extension UIApplication {
    func getNavigationController() throws -> UINavigationController? {
        guard let window = firstWindow else {
            throw NavigatorError.noWindow
        }
        
        guard let rootViewController = window.rootViewController else {
            throw NavigatorError.noNavigationController
        }
        
        return findNavigationController(viewController: rootViewController)
    }
    
    
    private func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let vc = viewController else {
            return nil
        }
        
        if let navigationController = vc as? UINavigationController {
            return navigationController
        }
        
        for childVC in vc.children {
            if let found = findNavigationController(viewController: childVC) {
                return found
            }
        }
        
        return nil
    }
}
