//
//  MusicHelper.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/30/21.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let backgroundPlayer = MusicHelper()
    static let instancePlayer = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bg-music", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func stopBackgroundMusic() {
        guard let player = audioPlayer else {
            return
        }
        player.stop()
    }
    
    func playSound(for resource: String) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: resource, ofType: "mp3")!)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            self.audioPlayer!.numberOfLoops = 0
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
