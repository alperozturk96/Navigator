//
//  NavigationAnimation.swift
//  
//
//  Created by Alper Ozturk on 2.09.2023.
//

import Foundation
import UIKit

/// A three-tupel that describes a custom push/pop animation.
public struct NavigationAnimation {
    /// The Core Animation transition type (e.g. `.moveIn`, `.fade`).
    public let transitionType: CATransitionType
    /// The timing function for pacing (e.g. `.easeInEaseOut`).
    public let timingFunction: CAMediaTimingFunctionName
    /// Duration in seconds.
    public let duration: CFTimeInterval
    
    /// Creates a new animation description.
    /// - Parameters:
    ///   - transitionType: the CATransitionType to apply.
    ///   - timingFunction: the CAMediaTimingFunctionName for pacing.
    ///   - duration: the duration (in seconds) of the animation.
    public init(
        transitionType: CATransitionType,
        timingFunction: CAMediaTimingFunctionName,
        duration: CFTimeInterval
    ) {
        self.transitionType = transitionType
        self.timingFunction = timingFunction
        self.duration = duration
    }
}
