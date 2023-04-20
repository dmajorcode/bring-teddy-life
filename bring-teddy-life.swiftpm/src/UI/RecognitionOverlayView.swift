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
    var check = 0
    var body: some View {
        VStack(alignment: .leading, spacing:30){
    
                    Button{
                        if audioRecorder.recording == true{
                            self.audioRecorder.stopRecording()
                        }

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
                    }.padding(60)

            Spacer()
            
        }
    }
    
}
