//
//  SwiftUIView.swift
//  
//
//  Created by Diane on 2023/04/18.
//

import SwiftUI

struct OutroView: View {
    var body: some View {
        VStack{
            Text("Thank you!")
                .font(.largeTitle)
            
            VStack{
                HStack{
                    Image("diane_baby")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 180)
                    Image("diane_adult")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                    
                }
                Text(" Baby Diane had a hard time sharing her most honest feelings and experiences with other people.")
                Spacer()
                    .frame(height: 12.0)
                 Text(" But with this Teddy, alive in app, baby Diane will be sharing everything. Also parent won't have to worry about baby Diane though she does not directly tell parent about what happened. Parent will get to know some things as Teddy will let them know sometimes.")
                    
                    
                    
            }
        }
        .padding(45)
        .frame(maxWidth: 600)
        
        
    }
}

struct OutroView_Previews: PreviewProvider {
    static var previews: some View {
        OutroView()
    }
}
