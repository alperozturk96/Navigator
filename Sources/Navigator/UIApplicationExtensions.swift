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

// MARK: - Navigations
extension UIApplication {
    func push<V: View>(view: V, identifier: String? = nil, animation: NavigationAnimation?, title: String?) throws {
        guard let navigationController = try getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        let targetVC = NavigatorView(rootView: view, identifier: identifier)
        
        if let title {
            targetVC.title = title
        }
        
        if navigationController.viewControllers.contains(where: { $0 === targetVC }) {
            return
        }
        
        if let animation = animation {
            addTransition(vc: targetVC, animation: animation)
        }
        
        navigationController.pushViewController(targetVC, animated: true)
    }
    
    func pop() throws {
        guard let navigationController = try getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        navigationController.popViewController(animated: true)
    }
    
    @discardableResult
    func popToView(_ identifier: String, animation: NavigationAnimation?) throws -> Bool {
        guard let navigationController = try getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        guard let targetVC = navigationController.viewControllers
            .compactMap({ $0 as? NavigatorView })
            .first(where: { $0.identifier == identifier }) else {
            throw NavigatorError.viewNotFound(identifier: identifier)
        }
        
        if let animation {
            addTransition(vc: targetVC, animation: animation)
        }
        
        navigationController.popToViewController(targetVC, animated: true)
        return true
    }
    
    func presentModal<V: View>(view: V, identifier: String?, title: String?) throws {
        guard let navigationController = try getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        let targetVC = NavigatorView(rootView: view, identifier: identifier)
        
        if let title {
            targetVC.title = title
        }
        
        if let topVC = navigationController.topViewController {
            topVC.present(targetVC, animated: true, completion: nil)
        }
    }
    
    func setNavigationStack<V: View>(stack: [(V, String?)]) throws {
        guard let window = firstWindow else {
            throw NavigatorError.noWindow
        }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = stack.map({ view, identifier in
            NavigatorView(rootView: view, identifier: identifier)
        })
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func setRootView<V: View>(view: V, identifier: String?) throws {
        try setNavigationStack(stack: [(view, identifier)])
    }
    
    func removeAllViews() throws {
        guard let navigationController = try getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        let viewControllersToRemove = navigationController.viewControllers
        
        for vc in viewControllersToRemove {
            vc.willMove(toParent: nil)
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
            vc.removeFromParent()
        }
        
        navigationController.viewControllers = []
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
    
    private func addTransition(vc: UIViewController, animation: NavigationAnimation) {
        let transition = CATransition()
        transition.duration = animation.duration
        transition.timingFunction = CAMediaTimingFunction(name: animation.mediaTimingFunction)
        transition.type = animation.transitionType
        vc.view.layer.add(transition, forKey: nil)
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
