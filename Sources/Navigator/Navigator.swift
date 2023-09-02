import SwiftUI

public struct Navigator {
 
    public static func pop() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.getNavigationController()?.popViewController(animated: true)
    }
    
    public static func popToRoot(animated: Bool = true) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        guard let navController = UIApplication.shared.getNavigationController() else {
            return
        }
        
        navController.popToRootViewController(animated: animated)
    }
    
    @discardableResult
    public static func popTo(_ navigationBarTitle: String) -> Bool {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        return UIApplication.shared.popToView(navigationBarTitle)
    }
    
    public static func push<V: View>(_ view: V, title: String? = nil) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.pushToView(view: view, title: title)
    }
    
    public static func removeAll() {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.removeAllViews()
    }
    
    public static func setStack<V: View>(_ views: [V]) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setNavigationStack(views: views)
    }
    
    public static func setRoot<V: View>(_ view: V) {
        assert(Thread.isMainThread, "Must be run on main thread")
        
        UIApplication.shared.setRootView(view: view)
    }
}
