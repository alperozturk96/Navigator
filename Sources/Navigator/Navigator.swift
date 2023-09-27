import SwiftUI

/// Navigator is a wrapper that uses UINavigationController.
///
/// Navigator uses UIApplication extensions to perform navigation according to needs such as pop, push, popTo specific View, present View modally etc.
public struct Navigator {
    
    /// Removes the last element from the navigation stack.
    /// e.g Before: A -> B | After: A
    ///
    /// Usage ``Navigator.pop()``
    public static func pop() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.pop()
    }
    
    /// Goes back to first element in the navigation stack.
    /// e.g Before: A -> B -> C -> D | After: A
    ///
    /// Usage ``Navigator.popToRoot()`` or ``Navigator.popToRoot(animated: false)``
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
    ///
    /// Usage ``Navigator.popTo("MovieList")``
    @discardableResult
    public static func popTo(_ navigationBarTitle: String, animation: NavigationAnimation? = nil) -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        return UIApplication.shared.popToView(navigationBarTitle, animation: animation)
    }
    
    /// Add new element in the navigation stack. For first use NavigationView must be used.
    /// e.g Before: A -> B -> C | After: A -> B -> C -> D
    ///
    /// Usage ``Navigator.push(MovieListView())``
    public static func push<V: View>(_ view: V, animation: NavigationAnimation? = nil, title: String? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.pushToView(view: view, animation: animation, title: title)
    }
    
    /// Remove all elements from navigation stack.
    ///
    /// Usage ``Navigator.removeAll()``
    public static func removeAll() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.removeAllViews()
    }
    
    /// Replace navigation stack with given navigation stack.
    /// e.g Before: A -> B -> C
    /// After: D -> E -> F
    ///
    /// Usage ``Navigator.setStack([MovieListView(), MovieListDetailView()])``
    public static func setStack<V: View>(_ views: [V]) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setNavigationStack(views: views)
    }
    
    /// Replace the navigation stack with a single View. You can achieve the same result by using setStack with a single element inside it.
    /// e.g Before: A -> B -> C
    /// After: D
    ///
    /// Usage ``Navigator.setRoot(HomeView())``
    public static func setRoot<V: View>(_ view: V) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setRootView(view: view)
    }
    
    /// Present given View modally.
    ///
    /// Usage ``Navigator.presentModal(AddMovieBottomSheet())``
    public static func presentModal<V: View>(_ view: V, title: String? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.presentModal(view: view, title: title)
    }
}
