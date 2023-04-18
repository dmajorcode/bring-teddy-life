import SwiftUI

enum Page: CaseIterable{
    case intro
//    record button should get in between
    case ar
    case outro
}

typealias NextAction = (() -> ())

struct ContentView: View {
    
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
                ARViewPlaceHolder(arView:ARTeddyView()){
                    guard currentPage == .ar else {return}
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
        
        var body: some View{
            ZStack{
                arView
//                arView.ignoresSafeArea()
//                InfoOverLayView(nextAction:nextAction)
            }
        }
    }
}
