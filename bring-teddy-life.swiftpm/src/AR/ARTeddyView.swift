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
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ARContentView()
        }
    }
}

struct ARContentView: View{
    var body: some View{
        ZStack{
//            ARTeddyViewController()
            Text("hi")
        }
    }
}

struct ARTeddyView_Previews: PreviewProvider {
    static var previews: some View {
        ARTeddyView()
    }
}
