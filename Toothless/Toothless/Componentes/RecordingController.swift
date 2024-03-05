//
//  RecordingController.swift
//  Toothless
//
//  Created by Simone Sarnataro on 05/03/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioRecorder: AVAudioRecorder!
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        requestAudioRecordingPermission()
    }

    func requestAudioRecordingPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Autorizzazione per la registrazione audio concessa")
            } else {
                print("L'utente ha negato l'autorizzazione per la registrazione audio")
            }
        }
    }

    @IBAction func toggleRecording(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    func startRecording() {
        let fileManager = FileManager.default
        do {
            // Creazione della nuova directory "NotifiHer" nella directory dei documenti dell'applicazione
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let notifiHerDirectory = documentsDirectory.appendingPathComponent("NotifiHer")
            try fileManager.createDirectory(at: notifiHerDirectory, withIntermediateDirectories: true, attributes: nil)

            // Percorso del file di registrazione all'interno della nuova directory
            let audioFilename = notifiHerDirectory.appendingPathComponent("recording.wav")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
            print("Registrazione audio avviata")
        } catch {
            print("Errore durante l'avvio della registrazione audio:", error.localizedDescription)
            // Handle error gracefully, e.g., show an alert
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        isRecording = false
        print("Registrazione audio terminata")
    }


//    func stopRecording() {
//        audioRecorder.stop()
//        audioRecorder = nil
//        isRecording = false
//        print("Registrazione audio terminata")
//
//        // Ottieni il percorso del file registrato
//        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Impossibile ottenere il percorso della directory dell'applicazione")
//            return
//        }
//        let audioFilename = documentsPath.appendingPathComponent("recording.wav")
//        
//        // Ottieni il percorso della cartella Download nell'app Files
//        guard let downloadsPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Mobile").appendingPathComponent("Downloads") else {
//            print("Impossibile ottenere il percorso della cartella Download")
//            return
//        }
//        
//        let destinationURL = downloadsPath.appendingPathComponent("recording.wav")
//
//        // Sposta il file registrato nella cartella Download
//        do {
//            try FileManager.default.moveItem(at: audioFilename, to: destinationURL)
//            print("Registrazione audio spostata nella cartella Downloads")
//        } catch {
//            print("Errore durante lo spostamento della registrazione nella cartella Downloads:", error.localizedDescription)
//        }
//    }
}

extension ViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Registrazione audio completata con successo")
        } else {
            print("Errore durante la registrazione audio")
            // Handle recording failure gracefully, e.g., show an alert
        }
    }
}
