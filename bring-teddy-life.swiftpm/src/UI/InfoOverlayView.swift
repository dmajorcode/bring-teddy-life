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
            HStack{

                Text("Say \"hello teddy\" to start recording little secret stories")
                
                
            }.padding()
            
            
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

struct InfoOverLayView_Previews: PreviewProvider {
    static var previews: some View {
        InfoOverLayView()
    }
}
