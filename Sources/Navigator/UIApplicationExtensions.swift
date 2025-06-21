//
//  UIApplicationExtensions.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import UIKit

// MARK: - UIWindow
extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first(where: \.isKeyWindow)
    }
    
    var navigationController: UINavigationController? {
        keyWindow?
            .rootViewController
            .flatMap { UIApplication.findNavigationController(viewController: $0) }
    }
}

// MARK: - Navigation Controller
extension UIApplication {
    private func addTransition(vc: UIViewController, animation: NavigationAnimation) {
        let transition = CATransition()
        transition.duration = animation.duration
        transition.timingFunction = CAMediaTimingFunction(name: animation.timingFunction)
        transition.type = animation.transitionType
        vc.view.layer.add(transition, forKey: nil)
    }
    
    private static func findNavigationController(viewController: UIViewController) -> UINavigationController? {
        if let navController = viewController as? UINavigationController {
            return navController
        }
        
        if let presentedVC = viewController.presentedViewController {
            if let found = findNavigationController(viewController: presentedVC) {
                return found
            }
        }
        
        for child in viewController.children {
            if let found = findNavigationController(viewController: child) {
                return found
            }
        }
        
        if let tabBarController = viewController as? UITabBarController,
           let selectedVC = tabBarController.selectedViewController {
            return findNavigationController(viewController: selectedVC)
        }
        
        return nil
    }
}
