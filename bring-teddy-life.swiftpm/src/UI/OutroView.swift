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
                VStack{
                    Text(" Baby Diane had a hard time sharing her most honest feelings and experiences with other people.")
                    HStack{
                        Spacer().frame(maxHeight:10)
                    }
                     Text(" But with this Teddy, baby Diane can be sharing whereever. Also parents won't have to worry about baby Diane though she does not directly speak to parents. Teddy will let them know sometimes.")
                }
                
                    
                    
                    
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
