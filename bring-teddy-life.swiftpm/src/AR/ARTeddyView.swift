//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct ARTeddyView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    var body: some View {
        ZStack{
            ARContentView(audioRecorder: audioRecorder)
        }
    }
}

struct ARContentView: View{
    @State private var recognitionState = false
    @ObservedObject var audioRecorder: AudioRecorder
    var body: some View{
        ZStack{
            ARTeddyViewControllerBridge(audioRecorder: audioRecorder, state: $recognitionState)
            RecognitionOverLayView(audioRecorder: audioRecorder)
            //                self.audioRecorder.startRecording()
        }
    }
}

//struct ARTeddyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARTeddyView(audioRecorder: AudioRecorder())
//    }
//}
