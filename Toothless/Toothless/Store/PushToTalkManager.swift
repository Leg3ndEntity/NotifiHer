////  PushToTalkManager.swift
////  Toothless
////
////  Created by Yuri Mario Gianoli on 22/02/24.
////
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

class ChannelDescriptorCache {
    static let shared = ChannelDescriptorCache()

    private var cache = [UUID: PTChannelDescriptor]()

    private init() {}

    func cacheDescriptor(_ descriptor: PTChannelDescriptor, forUUID uuid: UUID) {
        cache[uuid] = descriptor
    }

    func retrieveDescriptor(forUUID uuid: UUID) -> PTChannelDescriptor? {
        return cache[uuid]
    }
}

class PushToTalkViewController: UIViewController {
    // Add any properties or methods you need for your view controller
}

class PushToTalkManager: NSObject, ObservableObject {
    var channelManager: PTChannelManager!
    var channelDescriptor: PTChannelDescriptor!
    var channelUUID : UUID!
    weak var viewController: PushToTalkViewController?
    @Published var isTransmitting: Bool = false

    func setupChannelManager(viewController: PushToTalkViewController) async throws {
        self.viewController = viewController
        channelManager = try await PTChannelManager.channelManager(delegate: self, restorationDelegate: self)
    }
    func toggleTransmitting() {
            // Add your implementation here
            print("Toggling transmitting")
        }

    func joinChannel(channelUUID: UUID) {
        let channelImage = UIImage(named: "ChannelIcon")
        channelDescriptor = PTChannelDescriptor(name: "Awesome Crew", image: channelImage)
        channelManager.requestJoinChannel(channelUUID: channelUUID, descriptor: channelDescriptor)

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
    func joinChannel(channelName: String) {
        // Find a channel with the given name or create a new one if it doesn't exist
        let channelUUID = UUID() // Implement your logic to find or create a channel with the given name
        joinChannel(channelUUID: channelUUID)
    }
}

extension PushToTalkManager: PTChannelRestorationDelegate {
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        // Implement your logic to restore channel descriptor
        return PTChannelDescriptor(name: "", image: nil)
    }
    func updateChannel(_ channelDescriptor: PTChannelDescriptor, channelUUID: UUID) async throws {
        try await channelManager.setChannelDescriptor(channelDescriptor, channelUUID: channelUUID)
    }

    func reportServiceIsReconnecting() async throws {
        try await channelManager.setServiceStatus(.connecting, channelUUID: channelUUID)
    }
    func reportServiceIsConnected() async throws {
        try await channelManager.setServiceStatus(.ready, channelUUID: channelUUID)
    }
    func startTransmitting(){
        channelManager.requestBeginTransmitting(channelUUID: channelUUID)
    }
    func channelManager (_ channelManager: PTChannelManager, failedToBeginTransmittingChannel channelUUID: UUID, error: Error) {
        let error = error as NSError

        switch error.code {
        case PTChannelError.callActive.rawValue:
            print("The system has another ongoing call that is preventing transmission.")
        default:
            break
        }
    }

    func stopTransmitting() {
        channelManager.stopTransmitting(channelUUID: channelUUID)
    }
    func stopReceivingAudio() {
        channelManager.setActiveRemoteParticipant(nil, channelUUID: channelUUID)
    }
    func getActiveSpeakerImage(for speakerName: String) -> UIImage? {
        // Implement your logic to retrieve the cached image here
        // You might use your caching mechanism or retrieve it from a local storage

        // Example: Retrieving image from the ImageCacheManager
        let cachedImage = ImageCacheManager.shared.retrieveImage(forKey: speakerName)

        return cachedImage
    }

}









func getCachedChannelDescriptor(_ channelUUID: UUID) -> PTChannelDescriptor {
    guard let cachedDescriptor = ChannelDescriptorCache.shared.retrieveDescriptor(forUUID: channelUUID) else {
        // Se il descrittore del canale non è presente nella cache, restituisci un descrittore vuoto o di default
        return PTChannelDescriptor(name: "", image: nil)
    }
    return cachedDescriptor
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

func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
    return getCachedChannelDescriptor(channelUUID)

}

func channelManager(_ channelManager: PTChannelManager, failedToStopTransmittingInChannel channelUUID: UUID, error: Error){
    let error = error as NSError
    switch error.code {
    case PTChannelError.transmissionNotFound.rawValue:
        print("The user was not in a transmitting state")
    default:
        break
    }
}

func channelManager(_ channelManager: PTChannelManager,
                    channelUUID: UUID,
                    didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
    print("Did begin transmission from: \(source)")
}

func channelManager(_ channelManager: PTChannelManager,
                    didActivate audioSession: AVAudioSession) {
    print("Did activate audio session")
    // Configure your audio session and begin recording
}

func channelManager(_ channelManager: PTChannelManager,
                    channelUUID: UUID,
                    didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
    print("Did end transmission from: \(source)")
}

func channelManager(_ channelManager: PTChannelManager,
                    didDeactivate audioSession: AVAudioSession) {
    print("Did deactivate audio session")
    // Stop recording and clean up resources
}



