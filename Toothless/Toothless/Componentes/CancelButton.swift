//
//  CancelButton.swift
//  Toothless
//
//  Created by Simone Sarnataro on 29/02/24.
//

import SwiftUI

struct CancelButton: View {

    @State private var closed: Bool = false
    
    func closingButton(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(.easeInOut(duration: 1)) {
                self.closed = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            if closed {
                VStack (alignment: .trailing) {
                    ZStack{
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white.opacity(0.2))
                        Text("X")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                    .frame(width: 110, height: 40)
                .transition(.opacity)
                // Add transition for smooth animation
            } else {
                Rectangle()
                    .frame(width: 110, height: 40)
                    .cornerRadius(30)
                    .foregroundColor(.white.opacity(0.2))
                HStack {
                    Text("X")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("CANCEL")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .transition(.opacity) // Add transition for smooth animation
            }
        }
        .onAppear {
            self.closingButton()
        }
    }
}


#Preview {
    CancelButton()
}
