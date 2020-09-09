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
    
    var audioTimer: Timer?
    
    @Published var trackTime = ""
    
    //audio pulse
    var audioPulse: CGFloat = 0.0
    
    override init() {
        super.init()
        //self.playTrack(track: tracks[0].fileName)
        self.audioTimer?.invalidate()
        self.audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.audioUpdate), userInfo: nil, repeats: true)
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
    
    @objc func audioUpdate() {
        let minutes = secondsToMinutesSeconds(seconds: Int(audioPlayer.currentTime))
        let duration = secondsToMinutesSeconds(seconds: Int(audioPlayer.duration))
        
        trackTime = updatedTrackTime(m: minutes.0, s: minutes.1, dm: duration.0, ds: duration.1)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("audio complete")
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func updatedTrackTime(m: Int, s: Int, dm: Int, ds: Int) -> String {
        //print("m ", m, " .. ", s)
        return String(format: "%02d", m) + ":" + String(format: "%02d", s) + " / " + String(format: "%02d", dm) + ":" + String(format: "%02d", ds)
    }
}
