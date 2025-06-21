//
//  ViewExtensions.swift
//  
//
//  Created by Alper Ozturk on 2.09.2023.
//

import SwiftUI

extension View {
    func createNavigatorView(identifier: String?) -> NavigatorView {
        return NavigatorView(rootView: self, identifier: identifier)
    }
}
