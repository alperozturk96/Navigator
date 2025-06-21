//
//  NavigatorViewController.swift
//  Navigator
//
//  Created by Alper Ozturk on 21.06.25.
//
import SwiftUI

final class NavigatorViewController: UIViewController {
    private(set) var identifier: String?

    init(rootView: some View, identifier: String?) {
        self.identifier = identifier
        super.init(nibName: nil, bundle: nil)

        let hostingController = UIHostingController(rootView: rootView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
