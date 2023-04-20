//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct InfoOverLayView: View {
    var nextAction: NextAction?

    var body: some View {
        VStack{
            
            Spacer()
            Spacer()
            Button{
                nextAction?()
            } label: {
                Text("Next page")
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(5)
            }
            
        }
    }
}

//struct InfoOverLayView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoOverLayView()
//    }
//}
