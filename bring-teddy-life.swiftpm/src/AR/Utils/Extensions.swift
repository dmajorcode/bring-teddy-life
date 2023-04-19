//
//  File.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import UIKit
import SwiftUI
import RealityKit

// MARK: UI

extension UIView {
    func pin(to view: UIView) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

extension UIViewController {
    func toSwiftUI() -> ViewControllerWrapper {
        ViewControllerWrapper(viewController: self)
    }
}

struct ViewWrapper: UIViewRepresentable {
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

extension UIView {
    func toSwiftUI() -> ViewWrapper {
        ViewWrapper(view: self)
    }
}

extension Binding where Value == Bool {
    func negate() -> Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}


// MARK: AR

extension SIMD3 {
    static func all<T>(scalar: T) -> SIMD3<T> {
        .init(x: scalar, y: scalar, z: scalar)
    }
}

extension Entity {
    func scale(to scale: Float, duration: TimeInterval) {
        var scaleTransform = transform
        scaleTransform.scale = .all(scalar: scale)
        move(to: scaleTransform, relativeTo: parent, duration: duration, timingFunction: .easeInOut)
    }
}
