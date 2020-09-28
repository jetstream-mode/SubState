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
    
    private var currentSample: Int = 0
    private let numberOfSamples: Int = 25
    
    @Published var trackTime = ""
    @Published public var soundSamples: [Float] = []
    
    //audio pulse
    @Published var audioPulse: Int = 0
    
    //finished playing
    @Published var songComplete: Bool = false
    
    override init() {
        super.init()
        //self.playTrack(track: tracks[0].fileName)
        self.audioTimer?.invalidate()
        self.audioTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.audioUpdate), userInfo: nil, repeats: true)
        //self.audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.audioUpdate), userInfo: nil, repeats: true)
        
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
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
    
    func resumePlayer() {
        DispatchQueue.global(qos: .background).async {
            self.audioPlayer.play()
        }
    }
    
    func playTrack(track: String, playHead: TimeInterval? = nil) {

        let musicUrl = Bundle.main.url(forResource: track, withExtension: nil)
        
        if let musicUrl = musicUrl {
            DispatchQueue.global(qos: .background).async {
                do {
                    
                    try self.audioPlayer = AVAudioPlayer(contentsOf: musicUrl)
                    self.audioPlayer.delegate = self
                    self.audioPlayer.isMeteringEnabled = true
                    self.audioPlayer.prepareToPlay()
                    if let playHead = playHead {
                        self.audioPlayer.currentTime = playHead
                    }
                    self.audioPlayer.play()
                    DispatchQueue.main.async {
                        self.songComplete = false
                    }
                    
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
        
        //samples
        self.audioPlayer.updateMeters()
        self.soundSamples[self.currentSample] = self.audioPlayer.averagePower(forChannel: 0)
        self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        
        let sumSamples = soundSamples.reduce(0, +)
        audioPulse = abs(Int(sumSamples) / soundSamples.count)
        
        //debugPrint("audio current time ", self.audioPlayer.currentTime)
        //6.964988662131519
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("audio complete")
        self.songComplete = true
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func updatedTrackTime(m: Int, s: Int, dm: Int, ds: Int) -> String {
        //print("m ", m, " .. ", s)
        return String(format: "%02d", m) + ":" + String(format: "%02d", s) + " / " + String(format: "%02d", dm) + ":" + String(format: "%02d", ds)
    }
}
