//
//  PushToTalkManager.swift
//  Toothless
//
//  Created by Yuri Mario Gianoli on 22/02/24.
//

import Foundation
import PushToTalk
import AVFoundation
import UIKit

class PushToTalkManager: NSObject, ObservableObject {
    
    var channelManager: PTChannelManager!
    var channelDescriptor: PTChannelDescriptor!
    
    func setupChannelManager() async throws {
        channelManager = try await PTChannelManager.channelManager(delegate: self,
                                                                   restorationDelegate: self)
    }
    
    func joinChannel(channelUUID: UUID) {
        let channelImage = UIImage(named: "ChannelIcon")
        channelDescriptor = PTChannelDescriptor(name: "Awesome Crew", image: channelImage)
      
        // Ensure that your channel descriptor and UUID are persisted to disk for later use.
        channelManager.requestJoinChannel(channelUUID: channelUUID,
                                          descriptor: channelDescriptor)
    }
    
    
    
}

extension PushToTalkManager: PTChannelManagerDelegate {
    func incomingPushResult(channelManager: PTChannelManager, channelUUID: UUID, pushPayload: [String : Any]) -> PTPushResult {
        <#code#>
    }
    
    func channelManager( _ channelManager: PTChannelManager, didJoinChannel channelUUID: UUID, reason: PTChannelJoinReason) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didLeaveChannel channelUUID: UUID, reason: PTChannelLeaveReason) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, channelUUID: UUID, didBeginTransmittingFrom : PTChannelTransmitRequestSource) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, receivedEphemeralPushToken pushToken: Data) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didDeactivate audioSession: AVAudioSession) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didActivate audioSession: AVAudioSession) {
        
    }
    
    
    //manager delgate functions (guarda sulla documentazione) / "required" needs to be implemented here
}

extension PushToTalkManager: PTChannelRestorationDelegate {
    
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        PTChannelDescriptor(name: "", image: nil)
    }
    
    
    
}
