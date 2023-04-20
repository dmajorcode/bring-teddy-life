//
//  File.swift
//  
//
//  Created by Diane on 2023/04/20.
//

import Foundation
import SwiftUI

struct AudioRecordingsView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    var body: some View {
        ZStack{
            RecordingsListView(audioRecorder:audioRecorder)
//            Text("i am in recordingsview")
        }
    }
}
