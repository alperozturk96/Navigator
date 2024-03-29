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
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

// MARK: - Navigations
extension UIApplication {
    func presentModal<V: View>(view: V, title: String?) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        let targetVC = view.getVC()
        
        if let title {
            targetVC.title = title
        }
        
        if let topVC = navigationController.topViewController {
            topVC.present(targetVC, animated: true, completion: nil)
        }
    }
    
    func pushToView<V: View>(view: V, animation: NavigationAnimation?, title: String?) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        let targetVC = view.getVC()
        
        if let title {
            targetVC.title = title
        }
        
        if !navigationController.children.contains(targetVC) {
            if let animation {
                addTransition(vc: targetVC, animation: animation)
            }
            navigationController.pushViewController(targetVC, animated: true)
        }
    }

    @discardableResult
    func popToView(_ navigationBarTitle: String, animation: NavigationAnimation?) -> Bool {
        guard let navigationController = getNavigationController() else {
            return false
        }
        
        for vc in navigationController.children {
            if vc.navigationItem.title == navigationBarTitle {
                if let animation {
                    addTransition(vc: vc, animation: animation)
                }
                navigationController.popToViewController(vc, animated: true)
                return true
            }
        }
        
        return false
    }
    
    func pop() {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        navigationController.popViewController(animated: true)
    }
    
    func setNavigationStack<V: View>(views: [V]) {
        guard let window = firstWindow else { return }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = views.map({ view in
            view.getVC()
        })
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func setRootView<V: View>(view: V) {
        setNavigationStack(views: [view])
    }
    
    func removeAllViews() {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        navigationController.children.forEach({
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        })
    }
}

// MARK: - Navigation Controller
extension UIApplication {
    func getNavigationController() -> UINavigationController? {
        guard let window = firstWindow else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        guard let navigationController = findNavigationController(viewController: rootViewController) else { return nil }
        return navigationController
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
            return findNavigationController(viewController: childVC)
        }
        
        return nil
    }
}
