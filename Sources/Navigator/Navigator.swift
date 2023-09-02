import SwiftUI

public struct Navigator {
 
    /// Removes the last element from the navigation stack.
    /// e.g Before: A -> B | After: A
    public static func pop() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.getNavigationController()?.popViewController(animated: true)
    }
    
    /// Goes back to first element in the navigation stack.
    /// e.g Before: A -> B -> C -> D | After: A
    public static func popToRoot(animated: Bool = true) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navController = UIApplication.shared.getNavigationController() else {
            return
        }
        
        navController.popToRootViewController(animated: animated)
    }
    
    /// Goes back to specific element in the navigation stack with given title of View.
    /// e.g Before: A (title: "Home") -> B (title: "Item List") -> C (title: "Item Detail Page") -> D (title: "User Page")
    /// After: popTo(Item List) A -> B
    @discardableResult
    public static func popTo(_ navigationBarTitle: String) -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        return UIApplication.shared.popToView(navigationBarTitle)
    }
    
    /// Add new element in the navigation stack. For first use NavigationView must be used.
    /// e.g Before: A -> B -> C | After: A -> B -> C -> D
    public static func push<V: View>(_ view: V, title: String? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.pushToView(view: view, title: title)
    }
    
    /// Remove all elements from navigation stack.
    public static func removeAll() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.removeAllViews()
    }
    
    /// Replace navigation stack with given navigation stack.
    /// e.g Before: A -> B -> C
    /// After: D -> E -> F
    public static func setStack<V: View>(_ views: [V]) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setNavigationStack(views: views)
    }
    
    /// Replace the navigation stack with a single View. You can achieve the same result by using setStack with a single element inside it.
    /// e.g Before: A -> B -> C
    /// After: D
    public static func setRoot<V: View>(_ view: V) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setRootView(view: view)
    }
    
    /// Present given View modally.
    public static func presentModal<V: View>(_ view: V, title: String? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.presentModal(view: view, title: title)
    }
}
