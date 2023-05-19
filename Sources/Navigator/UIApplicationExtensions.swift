//
//  UIApplicationExtensions.swift
//  
//
//  Created by Alper Ozturk on 19.5.23..
//

import UIKit
import SwiftUI

public extension View {
    func getVC() -> UIViewController {
        return UIHostingController(rootView: self)
    }
}

public extension UIApplication {
    var firstWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    func pushToView<V: View>(view: V, title: String? = nil) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        let targetVC = view.getVC()
        
        if let title {
            targetVC.title = title
        }
        
        if !navigationController.children.contains(targetVC) {
            navigationController.pushViewController(targetVC, animated: true)
        }
    }

    @discardableResult
    func popToView(_ navigationBarTitle: String) -> Bool {
        guard let navigationController = getNavigationController() else {
            return false
        }
        
        for vc in navigationController.children {
            if vc.navigationItem.title == navigationBarTitle {
                navigationController.popToViewController(vc, animated: true)
                return true
            }
        }
        
        return false
    }
    
    func setNavigationStack(controllers: [UIViewController]) {
        guard let window = firstWindow else { return }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = controllers
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func setRootView<V: View>(view: V) {
        setNavigationStack(controllers: [view.getVC()])
    }
    
    func getNavigationController() -> UINavigationController? {
        guard let window = firstWindow else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        guard let navigationController = findNavigationController(viewController: rootViewController) else { return nil }
        return navigationController
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
