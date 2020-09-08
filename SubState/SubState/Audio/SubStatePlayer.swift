//
//  SubStatePlayer.swift
//  SubState
//
//  Created by Josh Kneedler on 9/8/20.
//

import Foundation
import AVFoundation

class SubStatePlayer: NSObject, AVAudioPlayerDelegate, ObservableObject {
    
    var tracks: [Tracks] = Bundle.main.decode([Tracks].self, from: "tracks.json")
    
    var audioPlayer = AVAudioPlayer()
    
    //audio pulse
    var audioPulse: CGFloat = 0.0
    
    override init() {
        super.init()
        //self.playTrack(track: tracks[0].fileName)
    }
    
    func stopPlayer() {
        DispatchQueue.global(qos: .background).async {
            self.audioPlayer.stop()
        }
    }
    
    func pausePlayer() {
        DispatchQueue.global(qos: .background).async {
            self.audioPlayer.pause()
        }
    }
    
    func playTrack(track: String) {
        
        let musicUrl = Bundle.main.url(forResource: track, withExtension: nil)
        
        if let musicUrl = musicUrl {
            DispatchQueue.global(qos: .background).async {
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: musicUrl)
                    self.audioPlayer.delegate = self
                    self.audioPlayer.isMeteringEnabled = true
                    self.audioPlayer.prepareToPlay()
                    //you were so bad
                    //self.audioPlayer.currentTime = Double((self.trackPlayer?.trackTime)!)!
                    self.audioPlayer.play()
                } catch {
                    debugPrint("error ", error)
                }
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("audio complete")
    }
    
}
