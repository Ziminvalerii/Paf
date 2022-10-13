//
//  AudioManager.swift
//  Paf
//
//  Created by Anastasia Koldunova on 06.10.2022.
//
import UIKit
import AVFoundation


enum SoundEffect {
    case gunShot
    case footSteps
    case glassBreak
    
    var soundName: String {
        switch self {
        case .gunShot:
            return "burstfire"
        case .footSteps:
            return "footsteps"
        case .glassBreak:
            return "glassBreak"
        }
    }
    
    var numberOfLoops: Int {
        switch self {
        case .gunShot:
            return 0
        case .footSteps:
            return -1
        case .glassBreak:
            return 0
        }
    }
}

class AudioManager {
    static let shared = AudioManager()
    
    var isSilent: Bool = false {
        didSet {
            if isSilent {
                if let player = player,
                   player.isPlaying {
                    player.pause()
                }
            } else {
                player?.play()
            }
        }
    }
    
    var IsVibrationOn = true
    
    private(set) var player: AVAudioPlayer?
    private(set) var gunShotPlayer: AVAudioPlayer?
    
    
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "backgroundMusic",
                                        withExtension: "mp3") else { return }
//        guard !isSilent else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.volume = 0.5
            player.numberOfLoops = -1
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound(_ soundType: SoundEffect) {
        guard let url = Bundle.main.url(forResource: soundType.soundName,
                                        withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            gunShotPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = gunShotPlayer else { return }
            player.volume = 1
            player.numberOfLoops = soundType.numberOfLoops
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func vibrate() {
        if IsVibrationOn {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
