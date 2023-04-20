//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import SwiftUI

struct RecognitionOverLayView: View {
//    @State var state: Bool
//    @ObservedObject var arTeddyViewController: ARTeddyViewController
    @ObservedObject var audioRecorder: AudioRecorder
    
    var nextAction: NextAction?
    
    var body: some View {
        VStack{
//            HStack{
//
//                Text("Say \"hello teddy\" to start recording little secret stories")
//
//
//            }.padding()
            
//            if state == true{
//                Text("true for sure")
//            }else{
//                Text("false for sure")
//            }
            
            Spacer()
            Button{
                nextAction?()
//                print("this is state", state)
                self.audioRecorder.stopRecording()
            } label: {
                Text("Next page")
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(5)
            }
            
        }
    }
    
}

//struct RecognitionOverLayView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecognitionOverLayView(state: <#T##Binding<Bool>#>)
//    }
//}
