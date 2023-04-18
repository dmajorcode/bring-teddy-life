//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct ButtonBridge: UIViewRepresentable{
    
    
    var title: String = "Continue"
    var action: () -> ()
    
    func makeUIView(context: Context) -> UIButton{
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.setTitle(title, for:[])
        button.addTarget(context.coordinator, action:#selector(context.coordinator.handleTap), for:.touchUpInside)
        return button
    }
    func updateUIView(_ uiView: UIButton, context: Context) {
    }
}

extension ButtonBridge{
    class Coordinator: NSObject{
        let parent: ButtonBridge
        init (_ parent:ButtonBridge){
            self.parent = parent
        }
        @objc func handleTap(){
            parent.action()
        }
    }
    func makeCoordinator() ->
        Coordinator{
                Coordinator(self)
        }
}
