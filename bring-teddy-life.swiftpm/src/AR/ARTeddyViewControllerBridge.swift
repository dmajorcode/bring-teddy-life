//
//  File.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import SwiftUI



struct ARTeddyViewControllerBridge: UIViewControllerRepresentable{
    @Binding var state: Bool
    func updateUIViewController(_ vc: ARTeddyViewController, context: Context) {
        vc.recognitionState = state
    }
    
    func makeUIViewController(context: Context) -> ARTeddyViewController{
        
        let vc = ARTeddyViewController()
        vc.recognitionState = state
        
        return vc
    }
}

//extension ARTeddyViewControllerBridge {
//    
//}
