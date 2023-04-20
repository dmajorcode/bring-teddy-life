//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct IntroView: View {
    var clickedNext: (() -> ())?
    var body: some View {
        
        VStack(spacing:50){
            Text("Hello!").font(.largeTitle).padding(10)
            
            VStack(spacing:50){
                
                HStack{
                    Image("diane_baby")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight:180)
                        .padding(5)
                    VStack{
                        Text("This is Baby Diane")
                        Spacer()
                            .frame(height: 12.0)
                        HStack{}
                        VStack{
                            Text("I have a little teddy that I always talk with. My parents brought teddy to me.")
                            
                            Spacer()
                                .frame(height: 12.0)
                            Text("I don't wanna tell parents everyting, I'd rather reach teddy. Sometimes I hope my parents would just know and help me.")
                        }   
                    }
                    
                }
                
                HStack{
                    
                    VStack{
                        Text("This is Diane")
                        Spacer()
                            .frame(height: 12.0)
                        Text("I brought baby Diane here to chat with Teddy.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 12.0)
                        Text("I can make what baby Diane had in mind to come in reality using AR.")
                            .multilineTextAlignment(.leading)
                    }
                    Image("diane_adult")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight:200)
                        .padding(3)
                    
                }
                ButtonBridge(title:"Continue"){
                    clickedNext?()
                }
                .frame(height:50)
            }.padding(20)
        }
//        .padding(40)
        .frame(maxWidth:600)
        
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
