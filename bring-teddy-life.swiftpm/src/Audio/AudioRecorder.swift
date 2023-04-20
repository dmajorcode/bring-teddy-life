//
//  File.swift
//  
//
//  Created by Diane on 2023/04/20.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

class AudioRecorder: NSObject, ObservableObject{
    override init(){
        super.init()
        fetchRecording()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false{
        didSet{
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        print("just started recording")
        do{
            try recordingSession.setCategory(.playAndRecord, mode:.default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-YY 'at' HH:mm:ss"
                return formatter
            }()
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(dateFormatter.string(from: Date())).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        print("lets stop recording")
        audioRecorder.stop()
        recording = false
        
        fetchRecording()
    }
    
    func fetchRecording(){
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents{
            let recording = Recording(fileURL: audio, createdAt: getFileDate(for:audio))
            recordings.append(recording)
        }
        recordings.sort(by: {$0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
            
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecording()
    }
}
