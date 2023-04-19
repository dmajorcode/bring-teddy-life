//
//  File.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import SwiftUI

struct ARTeddyViewControllerBridge: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: ARTeddyViewController, context: Context) {

    }
    
    
    func makeUIViewController(context: Context) -> ARTeddyViewController{
        let vc = ARTeddyViewController()
        return vc
    }
}
