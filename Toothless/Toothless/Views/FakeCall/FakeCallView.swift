//
//  FakeCallView.swift
//  Toothless
//
//  Created by Alessia Previdente on 04/03/24.
//
import SwiftUI

struct FakeCallView: View {
    @State var CallView = FakeCallsViewModel()
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    ForEach(CallView.fakecall){ fakecall in
                        NavigationLink(destination: SingleCallView(fakecall: fakecall)) {
                            ZStack(alignment: .bottom){
                                Image(fakecall.imagename)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 351 ,height: 174)
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                                                       startPoint: .top,
                                                       endPoint: .bottom)
                                    )
                                    .clipShape(Rectangle())
                                    .cornerRadius(15)
                                
                                HStack{
                                    Text(fakecall.situation)
                                        .font(.title2)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(fakecall.duration)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                }.frame(width:320)
                                    .padding(.bottom)
                            } .foregroundColor(.background)
                                .padding(.top, 10)
                            
                        }
                    }
                }
            }.navigationTitle("Fake Calls")
        }
    }
}


#Preview {
    FakeCallView()
}
