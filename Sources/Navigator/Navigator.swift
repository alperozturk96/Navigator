import SwiftUI

public struct Navigator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    /// Inits the Navigator
    ///
    @MainActor
    public init(window: UIWindow) throws {
        self.window = window
        
        guard let navigationController = UIApplication.shared.findNavigationController(viewController: window.rootViewController) else {
            print("🆘 No navigation controller found")
            throw NavigationError.noNavigationController
        }
        
        self.navigationController = navigationController
    }
}

// MARK: - Push
public extension Navigator {
    /// Pushes a SwiftUI view onto the navigation stack.
    ///
    /// - Parameters:
    ///   - view: The SwiftUI `View` to push.
    ///   - identifier: A string key to identify this view (optional).
    ///   - animation: A custom `NavigationAnimation` (optional).
    @MainActor
    func push<V: View>(_ view: V, identifier: String?, animation: NavigationAnimation? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        if let id = identifier,
           navigationController.viewControllers
             .compactMap({ $0 as? NavigatorViewController })
             .contains(where: { $0.identifier == id }) {
            print("🆘 View with identifier '\(id)' already exists.")
          return
        }
        
        let vc = NavigatorViewController(rootView: view, identifier: identifier)
        
        if let animation = animation {
            addTransition(vc: vc, animation: animation)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - POP
public extension Navigator {
    /// Pops the from the last view.
    @MainActor
    func pop() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        navigationController.popViewController(animated: true)
    }
    
    /// Pops until the view with the given identifier is on top.
    ///
    /// - Parameters:
    ///   - identifier: The identifier you assigned when pushing.
    ///   - animation: A custom animation to apply to the target view (optional).
    /// - Returns: `true` if the pop succeeded.
    ///   - `NavigatorError.viewNotFound(identifier:)`
    @MainActor
    @discardableResult
    func popTo(_ identifier: String, animation: NavigationAnimation? = nil) throws -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let targetVC = navigationController.viewControllers
            .compactMap({ $0 as? NavigatorViewController })
            .first(where: { $0.identifier == identifier }) else {
            print("🆘 View identifier not found: \(identifier)")
            throw NavigationError.viewNotFound(identifier: identifier)
        }
        
        if let animation {
            addTransition(vc: targetVC, animation: animation)
        }
        
        navigationController.popToViewController(targetVC, animated: true)
        return true
    }
    
    /// Pops all view controllers until root presents.
    /// - Parameter animated: whether to animate the pop (default `true`).
    @MainActor
    func popToRoot(animated: Bool = true) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        navigationController.popToRootViewController(animated: animated)
    }
}


// MARK: - Navigation Stack
public extension Navigator {
    /// Replaces the entire navigation stack with the given views.
    ///
    /// - Parameter stack: An array of `(View, String?)` tuples.
    @MainActor
    func setStack<V: View>(_ stack: [(V, String?)]) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        setNavigationStack(stack: stack)
    }
    
    /// Clears out all view controllers from the current nav stack.
    @MainActor
    func clearStack() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
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
    
    /// Sets a single SwiftUI view as the root (clears stack).
    @MainActor
    func setRoot<V: View>(_ view: V, identifier: String?) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        setNavigationStack(stack: [(view, identifier)])
    }
    
    @MainActor
    private func setNavigationStack<V: View>(stack: [(V, String?)]) {
        let navigationController = UINavigationController()
        navigationController.viewControllers = stack.map({ view, identifier in
            NavigatorViewController(rootView: view, identifier: identifier)
        })
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

// MARK: - Modal
public extension Navigator {
    /// Presents a SwiftUI view modally on top of the current top.
    ///
    /// - Parameters:
    ///   - view: The view to present.
    ///   - identifier: An optional key for later dismissal/lookup.
    @MainActor
    func presentModal<V: View>(_ view: V, identifier: String?) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        let vc = NavigatorViewController(rootView: view, identifier: identifier)
        
        let modal = UINavigationController(rootViewController: vc)
        navigationController.topViewController?.present(modal, animated: true)
    }
}

// MARK: - Helper Methods
extension Navigator {
    @MainActor
    private func addTransition(vc: UIViewController, animation: NavigationAnimation) {
        let transition = CATransition()
        transition.duration = animation.duration
        transition.timingFunction = CAMediaTimingFunction(name: animation.timingFunction)
        transition.type = animation.transitionType
        vc.view.layer.add(transition, forKey: nil)
    }
}
