//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import SwiftUI

struct RecognitionOverLayView: View {
    @Binding var state: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                if state == true{
                    Text("true for sure")
                }else{
                    Text("false for sure")
                }
                
                
                
            }.padding()
            
            
            Spacer()
            
            
        }
    }
}

//struct RecognitionOverLayView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecognitionOverLayView(state: <#T##Binding<Bool>#>)
//    }
//}
