//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct ARTeddyView: View {
    var body: some View {
        ZStack{
            ARContentView()
        }
    }
}

struct ARContentView: View{
    @State private var recognitionState = false
    var body: some View{
        ZStack{
            ARTeddyViewControllerBridge(state: $recognitionState)
            RecognitionOverLayView(state: $recognitionState)
        }
    }
}

struct ARTeddyView_Previews: PreviewProvider {
    static var previews: some View {
        ARTeddyView()
    }
}
