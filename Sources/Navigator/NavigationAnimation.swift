//
//  NavigationAnimation.swift
//  
//
//  Created by Alper Ozturk on 2.09.2023.
//

import Foundation
import UIKit

public struct NavigationAnimation {
    let transitionType: CATransitionType
    let mediaTimingFunction: CAMediaTimingFunctionName
    let duration: CFTimeInterval
    
    public init(transitionType: CATransitionType, mediaTimingFunction: CAMediaTimingFunctionName, duration: CFTimeInterval) {
        self.transitionType = transitionType
        self.mediaTimingFunction = mediaTimingFunction
        self.duration = duration
    }
}
