import SwiftUI

/// Navigator is a wrapper that uses UINavigationController.
///
/// Navigator uses UIApplication extensions to perform navigation according to needs such as pop, push, popTo specific View, present View modally etc.
public struct Navigator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    /// Inits the Navigator
    ///
    /// - Parameters:
    ///   - rootView: the SwiftUI `View` you want at the bottom of the stack.
    ///   - identifier: an optional string key to identify this root view.
    @MainActor
    public init<V: View>(
        window: UIWindow,
        rootView: V,
        identifier: String? = nil,
    ) {
        let rootVC = NavigatorView(rootView: rootView, identifier: identifier)
        let nav = UINavigationController(rootViewController: rootVC)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        self.window = window
        self.navigationController = nav
    }
    
    @MainActor
    private func addTransition(vc: UIViewController, animation: NavigationAnimation) {
        let transition = CATransition()
        transition.duration = animation.duration
        transition.timingFunction = CAMediaTimingFunction(name: animation.timingFunction)
        transition.type = animation.transitionType
        vc.view.layer.add(transition, forKey: nil)
    }
    
    
    // MARK: Push
    
    /// Pushes a SwiftUI view onto the navigation stack.
    ///
    /// - Parameters:
    ///   - view: The SwiftUI `View` to push.
    ///   - identifier: A string key to identify this view (optional).
    ///   - animation: A custom `NavigationAnimation` (optional).
    ///   - title: The title shown in the nav bar (optional).
    /// - Throws: `NavigatorError.noNavigationController` if no nav controller exists.
    @MainActor
    public func push<V: View>(_ view: V, identifier: String?, animation: NavigationAnimation? = nil, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        if let id = identifier,
           navigationController.viewControllers
             .compactMap({ $0 as? NavigatorView })
             .contains(where: { $0.identifier == id }) {
          return
        }
        
        let targetVC = NavigatorView(rootView: view, identifier: identifier)
        
        if let title {
            targetVC.title = title
        }
        
        if let animation = animation {
            addTransition(vc: targetVC, animation: animation)
        }
        
        navigationController.pushViewController(targetVC, animated: true)
    }
    
    // MARK: Pop
    
    /// Pops the from the last view.
    /// - Throws: `NavigatorError.noNavigationController` if not embedded.
    @MainActor
    public func pop() throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        navigationController.popViewController(animated: true)
    }
    
    /// Pops until the view with the given identifier is on top.
    ///
    /// - Parameters:
    ///   - identifier: The identifier you assigned when pushing.
    ///   - animation: A custom animation to apply to the target view (optional).
    /// - Returns: `true` if the pop succeeded.
    /// - Throws:
    ///   - `NavigatorError.noNavigationController`
    ///   - `NavigatorError.viewNotFound(identifier:)`
    @MainActor
    @discardableResult
    public func popTo(_ identifier: String, animation: NavigationAnimation? = nil) throws -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
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
    
    /// Pops all view controllers until root presents.
    /// - Parameter animated: whether to animate the pop (default `true`).
    /// - Throws: `NavigatorError.noNavigationController`.
    @MainActor
    public func popToRoot(animated: Bool = true) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navController = try UIApplication.shared.getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        navController.popToRootViewController(animated: animated)
    }
    
    /// Clears out all view controllers from the current nav stack.
    /// - Throws: `NavigatorError.noNavigationController`.
    @MainActor
    public func clearStack() throws {
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
    
    // MARK: Reset & Replace
    
    /// Replaces the entire navigation stack with the given views.
    ///
    /// - Parameter stack: An array of `(View, String?)` tuples.
    /// - Throws: `NavigatorError.noWindow`.
    @MainActor
    public func setStack<V: View>(_ stack: [(V, String?)]) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        setNavigationStack(stack: stack)
    }
    
    @MainActor
    func setNavigationStack<V: View>(stack: [(V, String?)]) {
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
    
    /// Sets a single SwiftUI view as the root (clears stack).
    /// - Throws: `NavigatorError.noWindow`.
    @MainActor
    public func setRoot<V: View>(_ view: V, identifier: String?) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        setNavigationStack(stack: [(view, identifier)])
    }
    
    // MARK: Modal
    
    /// Presents a SwiftUI view modally on top of the current top.
    ///
    /// - Parameters:
    ///   - view: The view to present.
    ///   - identifier: An optional key for later dismissal/lookup.
    ///   - title: The nav-bar title if you wrap it in a UINavigationController.
    @MainActor
    public func presentModal<V: View>(_ view: V, identifier: String?, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        let vc = NavigatorView(rootView: view, identifier: identifier)
        vc.title = title
        
        let modal = UINavigationController(rootViewController: vc)
        navigationController.topViewController?.present(modal, animated: true)
    }
}
