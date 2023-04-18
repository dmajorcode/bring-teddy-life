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
            Text("Hello!")
            ARContentView()
        }
    }
}

struct ARContentView: View{
    var body: some View{
        ZStack{

            Text("hi")
//            ARTeddyViewController()
        }
    }
}

struct ARTeddyView_Previews: PreviewProvider {
    static var previews: some View {
        ARTeddyView()
    }
}
