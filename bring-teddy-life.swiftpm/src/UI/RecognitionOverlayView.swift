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

            Spacer()
            
            Button{

                if audioRecorder.recording == true{
                    self.audioRecorder.stopRecording()
                }
                print("this is recordings", self.audioRecorder.recordings)
            } label: {
                if audioRecorder.recording == true{
                    Text("Stop remembering me")
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(5)
                } else {
                    Text("Say Remember me Teddy")
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(5)
                }
                
            }
            
        }
    }
    
}

//struct RecognitionOverLayView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecognitionOverLayView(state: <#T##Binding<Bool>#>)
//    }
//}
