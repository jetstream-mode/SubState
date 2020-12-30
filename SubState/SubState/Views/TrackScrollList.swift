//
//  TrackScrollList.swift
//  SubState
//
//  Created by Josh Kneedler on 11/30/20.
//

import Foundation
import SwiftUI

struct TrackScrollList: View, NormalizeSound {

    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer

    var currentYOffset: CGFloat {
        return -((CGFloat(evaluator.selectedKey) * 50) - 200)
    }
        
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.gray, .offWhite]), startPoint: .top, endPoint: .bottomTrailing))
                    .frame(width: 50, height: geometry.size.height)
                    .offset(x: 50)
                
                HStack(alignment: .top, spacing: 1) {
                    ForEach(subStatePlayer.soundSamples, id: \.self) { level in
                        SoundBarView(soundValue: self.normalizeSoundLevel(level: level), barColor: .blue, barOpacity: 0.5, barWidth: 1.0)
                    }
                }
                .offset(x: 50, y: 0)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(evaluator.tracks) { track in
                        Button(action: {
                            if let trackButtonHit = Int(track.id) {
                                evaluator.selectedKey = trackButtonHit
                            }
                        }) {
                            TrackCell(evaluator: self.evaluator, subStatePlayer: subStatePlayer, track: track)
                                .id(Int(track.id))
                                .transition(.slide)
                        }

                    }
                    Spacer()
                }
                .offset(y: currentYOffset)
                
            }
            .animation(.default)
        }
    }
}

struct TrackCell: View {
    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer
    
    var track: Tracks
    let keyShapeSize: CGFloat = 25
    
    var trackId: Int {
        return Int(track.id) ?? 0
    }
    
    var trackOpacity: Double {
        if trackId == evaluator.selectedKey {
            return 0.8
        } else {
            return 0.2
        }
    }
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            Image(track.vinylFile)
                .resizable()
                .opacity(trackOpacity)
                .frame(width: 50, height: 50)
                .offset(x: 0)
            Spacer()
                .frame(width: 0)
            switch trackId {
            case 0:
                KeyOneRaw()
                    .foregroundColor(.white)
                    .frame(width: keyShapeSize/2, height: keyShapeSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .opacity(trackOpacity)
                    .offset(x: 15)
            case 1:
                KeyTwoRaw()
                    .foregroundColor(.white)
                    .frame(width: keyShapeSize/2, height: keyShapeSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .opacity(trackOpacity)
                    .offset(x: 15)
            case 2:
                KeyThreeRaw()
                    .foregroundColor(.white)
                    .frame(width: keyShapeSize/2, height: keyShapeSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .opacity(trackOpacity)
                    .offset(x: 15)
            default:
                KeyThreeRaw()
                    .foregroundColor(.white)
                    .frame(width: keyShapeSize/2, height: keyShapeSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .opacity(trackOpacity)
                    .offset(x: 15)
                
            }

            Spacer()
                .frame(width: 50)
            VStack(alignment: .leading) {
                Text("\(track.song)")
                    .font(.custom("DIN Condensed Bold", size: 16))
                    .foregroundColor(Color.gray)
                HStack {
                    Text("\(track.artist)")
                        .font(.custom("DIN Condensed Bold", size: 12))
                        .foregroundColor(Color.gray)
                    if trackId == evaluator.selectedKey {
                        Text("\(subStatePlayer.trackTime)")
                            .font(.custom("DIN Condensed Bold", size: 12))
                            .foregroundColor(Color.gray)
                    }
                }

            }
            .opacity(trackOpacity)
        }
        .frame(height: 50)
    }
}
