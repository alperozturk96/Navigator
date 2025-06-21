import SwiftUI

/// Navigator is a wrapper that uses UINavigationController.
///
/// Navigator uses UIApplication extensions to perform navigation according to needs such as pop, push, popTo specific View, present View modally etc.
public struct Navigator {
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
    public static func push<V: View>(_ view: V, identifier: String?, animation: NavigationAnimation? = nil, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.push(view: view, identifier: identifier, animation: animation, title: title)
    }
    
    // MARK: Pop
    
    /// Pops the from the last view.
    /// - Throws: `NavigatorError.noNavigationController` if not embedded.
    @MainActor
    public static func pop() throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.pop()
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
    public static func popTo(_ identifier: String, animation: NavigationAnimation? = nil) throws -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        return try UIApplication.shared.popToView(identifier, animation: animation)
    }
    
    /// Pops all view controllers until root presents.
    /// - Parameter animated: whether to animate the pop (default `true`).
    /// - Throws: `NavigatorError.noNavigationController`.
    @MainActor
    public static func popToRoot(animated: Bool = true) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navController = try UIApplication.shared.getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        navController.popToRootViewController(animated: animated)
    }
    
    /// Clears out all view controllers from the current nav stack.
    /// - Throws: `NavigatorError.noNavigationController`.
    @MainActor
    public static func clearStack() throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.removeAllViews()
    }
    
    // MARK: Reset & Replace
    
    /// Replaces the entire navigation stack with the given views.
    ///
    /// - Parameter stack: An array of `(View, String?)` tuples.
    /// - Throws: `NavigatorError.noWindow`.
    @MainActor
    public static func setStack<V: View>(_ stack: [(V, String?)]) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.setNavigationStack(stack: stack)
    }
    
    /// Sets a single SwiftUI view as the root (clears stack).
    /// - Throws: `NavigatorError.noWindow`.
    @MainActor
    public static func setRoot<V: View>(_ view: V, identifier: String?) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.setRootView(view: view, identifier: identifier)
    }
    
    // MARK: Modal
    
    /// Presents a SwiftUI view modally on top of the current top.
    ///
    /// - Parameters:
    ///   - view: The view to present.
    ///   - identifier: An optional key for later dismissal/lookup.
    ///   - title: The nav-bar title if you wrap it in a UINavigationController.
    @MainActor
    public static func presentModal<V: View>(_ view: V, identifier: String?, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navigationController = try UIApplication.shared.getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        let vc = NavigatorView(rootView: view, identifier: identifier)
        vc.title = title
        
        let modal = UINavigationController(rootViewController: vc)
        navigationController.topViewController?.present(modal, animated: true)
    }
}
