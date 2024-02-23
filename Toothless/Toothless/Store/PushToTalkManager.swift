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

class ImageCacheManager {
    static let shared = ImageCacheManager() // Singleton instance
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>() // Use NSCache for simple in-memory caching
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

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
    func channelManager(_ channelManager: PTChannelManager, channelUUID: UUID, didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
        
    }
    func channelManager(_ channelManager: PTChannelManager, channelUUID: UUID, didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
        
    }
    
    func incomingPushResult(channelManager: PTChannelManager, channelUUID: UUID, pushPayload: [String : Any]) -> PTPushResult {
        
        guard let activeSpeaker = pushPayload["activeSpeaker"] as? String else {
            // Report that there's no active speaker, so leave the channel.
            return .leaveChannel
        }
        
        // Assuming you have a function to retrieve the cached image
        // Replace "getCachedImage" with the actual function name that retrieves cached images
        let activeSpeakerImage = getCachedImage(for: activeSpeaker)
        
        let participant = PTParticipant(name: activeSpeaker, image: activeSpeakerImage)
        
        // Report the active participant information to the system.
        return .activeRemoteParticipant(participant)
    }
    
    // Function to retrieve the cached image for a given speaker name
    func getCachedImage(for speakerName: String) -> UIImage? {
        // Implement your logic to retrieve the cached image here
        // You might use your caching mechanism or retrieve it from a local storage
        
        // Example: Retrieving image from cache
        let cachedImage = ImageCacheManager.shared.retrieveImage(forKey: speakerName)
        
        return cachedImage
    }
    
    func channelManager( _ channelManager: PTChannelManager, didJoinChannel channelUUID: UUID, reason: PTChannelJoinReason) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didLeaveChannel channelUUID: UUID, reason: PTChannelLeaveReason) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, receivedEphemeralPushToken pushToken: Data) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didDeactivate audioSession: AVAudioSession) {
        
    }
    
    func channelManager( _ channelManager: PTChannelManager, didActivate audioSession: AVAudioSession) {
        
    }
}

extension PushToTalkManager: PTChannelRestorationDelegate {
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        // Implement your logic to restore channel descriptor
        return PTChannelDescriptor(name: "", image: nil)
    }
}

// These functions were declared twice and one of them was missing its implementation
// I'm assuming you meant to put these outside the class
func chanelManager(_ channelManager: PTChannelManager, didJoinChannel channelUUID: UUID, reason: PTChannelJoinReason) {
    print ("Joined channel with UUID: \(channelUUID)")
}

func channelManager(_ channelManager: PTChannelManager, receivedEphemeralPushToke pushToken: Data) {
    print ("Received push token")
}

func channelManager(_ channelManager: PTChannelManager, failedToJoinChannel channelUUID: UUID, error: Error) {
    let error = error as NSError
    switch error.code {
    case PTChannelError.channelLimitReached.rawValue:
        print ("The user has already joined a channel")
    default:
        break
    }
}

func channelManager(_ channelManager: PTChannelManager, didLeaveChannel channelUUID: UUID, reason: PTChannelLeaveReason) {
    print ("Left channel with UUID: \(channelUUID)")
}

func updateChannel(_ channelDescriptor: PTChannelDescriptor) async throws {
    try await channelManager.setChannelDescriptor(channelDescriptor, channelUUID: channelUUID)
}
