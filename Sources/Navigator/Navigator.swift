import SwiftUI

/// Navigator is a wrapper that uses UINavigationController.
///
/// Navigator uses UIApplication extensions to perform navigation according to needs such as pop, push, popTo specific View, present View modally etc.
public struct Navigator {
    
    @MainActor
    public static func push<V: View>(_ view: V, identifier: String?, animation: NavigationAnimation? = nil, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.push(view: view, identifier: identifier, animation: animation, title: title)
    }
    
    @MainActor
    public static func pop() throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.pop()
    }
    
    @MainActor
    @discardableResult
    public static func popTo(_ identifier: String, animation: NavigationAnimation? = nil) throws -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        return try UIApplication.shared.popToView(identifier, animation: animation)
    }
    
    @MainActor
    public static func popToRoot(animated: Bool = true) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navController = try UIApplication.shared.getNavigationController() else {
            throw NavigatorError.noNavigationController
        }
        
        navController.popToRootViewController(animated: animated)
    }
    
    @MainActor
    public static func removeAll() throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.removeAllViews()
    }
    
    @MainActor
    public static func setStack<V: View>(_ stack: [(V, String?)]) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.setNavigationStack(stack: stack)
    }
    
    @MainActor
    public static func setRoot<V: View>(_ view: V, identifier: String?) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.setRootView(view: view, identifier: identifier)
    }
    
    @MainActor
    public static func presentModal<V: View>(_ view: V, identifier: String?, title: String? = nil) throws {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        try UIApplication.shared.presentModal(view: view, identifier: identifier, title: title)
    }
}
