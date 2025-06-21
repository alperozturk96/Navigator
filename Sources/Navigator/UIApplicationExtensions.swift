//
//  UIApplicationExtensions.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//

import UIKit

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
    private func addTransition(vc: UIViewController, animation: NavigationAnimation) {
        let transition = CATransition()
        transition.duration = animation.duration
        transition.timingFunction = CAMediaTimingFunction(name: animation.timingFunction)
        transition.type = animation.transitionType
        vc.view.layer.add(transition, forKey: nil)
    }
    
    func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
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
