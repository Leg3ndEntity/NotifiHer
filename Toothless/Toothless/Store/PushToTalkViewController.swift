//
//  PushToTalkViewController.swift
//  Toothless
//
//  Created by Yuri Mario Gianoli on 01/03/24.
//

import SwiftUI
import PushToTalk

struct PushToTalkView: View {
    @ObservedObject var pushToTalkManager: PushToTalkManager
    @State private var selectedChannel: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("Select Channel:")
                Spacer()
                TextField("Enter channel name", text: $selectedChannel)
                Button(action: {
                    pushToTalkManager.joinChannel(channelName: selectedChannel)
                }) {
                    Text("Join Channel")
                }
            }

            HStack {
                Spacer()
                Button(action: {
                    pushToTalkManager.toggleTransmitting()
                }) {
                    Image(systemName: pushToTalkManager.isTransmitting ? "mic.fill" : "mic")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Spacer()
            }
        }
        .padding()
    }
}




struct PushToTalkView_Previews: PreviewProvider {
    static var previews: some View {
        PushToTalkView(pushToTalkManager: PushToTalkManager())
    }
}
