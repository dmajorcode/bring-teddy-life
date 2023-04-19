import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecorder: AudioRecorder())
        }
    }
}
  
