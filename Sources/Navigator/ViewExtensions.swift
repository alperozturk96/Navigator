//
//  File.swift
//  
//
//  Created by Alper Ozturk on 2.09.2023.
//

import SwiftUI

extension View {
    func getVC() -> UIViewController {
        return UIHostingController(rootView: self)
    }
}
