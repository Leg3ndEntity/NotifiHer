//
//  SingleCallView.swift
//  Toothless
//
//  Created by Alessia Previdente on 04/03/24.
//

import SwiftUI
import AVKit

struct SingleCallView: View {
    var fakecall: FakeCall
    @State private var player: AVPlayer?
    @State var isPlaying = false
    @State var totalTime : TimeInterval = 0.0
    var body: some View {
        NavigationStack{
            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: fakecall.video, withExtension: "MOV" )!))
        }.navigationTitle(fakecall.situation)
    }
}

#Preview {
    SingleCallView(fakecall:  FakeCall(situation: "Taxi/Uber", duration: "15 min", imagename: "Taxi", video: "VideoProva"))
}
