import SwiftUI

enum Page: CaseIterable{
    case intro
    case ar
    case recordingsList
    case outro
}

typealias NextAction = (() -> ())

struct ContentView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State private var currentPageIndex = 0
    var currentPage: Page{
        Page.allCases[currentPageIndex]
    }
    
    var body: some View {
        ZStack{
            switch currentPage {
            case .intro:
                IntroView {
                    guard currentPage == .intro else {return}
                    currentPageIndex += 1
                }
            case .ar:
                ARViewPlaceHolder(arView:ARTeddyView(audioRecorder: audioRecorder)){
                    guard currentPage == .ar else {return}
                    currentPageIndex += 1
                }
            case .recordingsList:
                RecordingsViewPlaceHolder(audioRecordingsView: AudioRecordingsView(audioRecorder: audioRecorder)){
                    guard currentPage == .recordingsList else {return}
                    currentPageIndex += 1
                }

            case .outro:
                OutroView()
            }
        }
        .animation(.default, value:currentPageIndex)
    }
    
    func nextPage(){
        currentPageIndex += 1
    }
}

extension ContentView{
    struct ARViewPlaceHolder<T: View> : View{
        var arView: T
        var nextAction: NextAction?
//        @ObservedObject var audioRecorder: AudioRecorder
        var body: some View{
            ZStack{
                arView.ignoresSafeArea()
                InfoOverLayView(nextAction:nextAction)
//                RecognitionOverLayView(audioRecorder: audioRecorder, nextAction:nextAction)
            }
        }
    }
    
    struct RecordingsViewPlaceHolder<T: View> : View{
        var audioRecordingsView: T
        var nextAction: NextAction?
        
        var body: some View{
            ZStack{
                audioRecordingsView
                InfoOverLayView(nextAction:nextAction)
            }
        }
    }
}
