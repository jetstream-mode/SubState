//
//  ContentView.swift
//  keyOneShapesTest
//
//  Created by Josh Kneedler on 8/5/20.
//

import SwiftUI

struct ContentView: View {
    @DataLoader("tracks.json") private var tracks: [Tracks]
    
    @ObservedObject var subStatePlayer = SubStatePlayer()
    @State var currentTime: String = ""
    @State var soundSamples: [Float] = []
    @State var audioPulse: Int = 0
    //wave properties
    @State var phase: Double = 0.0
    @State var waveStrength: Double = 0.0
    @State var waveFrequency: Double = 10.0
    
    let keySize: CGFloat = 25
    @State var selectedKey: Int = 0
    @State var slideOpen: Bool = false
    @State var allKeys: [Any] = [KeyOne.self, KeyTwo.self, KeyThree.self, KeyFour.self, KeyFive.self, KeySix.self, KeySeven.self, KeyEight.self, KeyNine.self, KeyTen.self, KeyEleven.self, KeyTwelve.self]
    
    @State var keyDragId: Int = 0
    
    @State var navigationState: Int = 0
    

    var body: some View {
        ZStack {
            Color.offWhite

            if navigationState == 1 && slideOpen {
                /*
                EmitterView(images: ["homecoming"], particleCount: 20, creationPoint: .init(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), colors: [.red, .blue], angle: Angle(degrees: 180), angleRange: Angle(radians: .pi / 4), rotationRange: Angle(radians: .pi * 2), rotationSpeed: Angle(radians: .pi), scale: 0.6, speed: 1200, speedRange: 800, animation: Animation.linear(duration: 15).repeatForever(autoreverses: false), animationDelayThreshold: 5)
                 
                 AnyView(KeyOneRaw()
                             .foregroundColor(.gray)
                             .frame(width: 10, height: 10))
                 
                 particleViews: [AnyView(KeyOneRaw()
                                 .foregroundColor(.gray)
                                 .frame(width: 50, height: 50)
                                             .blur(radius: CGFloat.random(in: 0...10))
                 
                 AnyView(Image("confetti"))
 */
                if selectedKey == 1 {
                    EmitterView(
                        particleViews: [AnyView(KeyOneRaw()
                                                    .foregroundColor(.gray)
                                                    .frame(width: 10, height: 10))],
                        particleCount: 20 + audioPulse,
                        creationPoint: .leading,
                        creationRange: CGSize(width: 0, height: 0),
                        colors: [.gray, .red],
                        alphaSpeed: 10,
                        angle: Angle(degrees: 90),
                        angleRange: Angle(degrees: 0),
                        //rotation: Angle(degrees: Double(audioPulse)),
                        //rotationRange: Angle(degrees: Double(audioPulse)),
                        //rotationSpeed: Angle(degrees: Double(audioPulse)),
                        scale: CGFloat(audioPulse) * 0.3,
                        scaleRange: CGFloat(audioPulse) * 0.3,
                        scaleSpeed: 0.4,
                        speed: 1200,
                        speedRange: Double(audioPulse * 25),
                        animation: Animation.linear(duration: 2).repeatForever(autoreverses: true).delay(0.5), animationDelayThreshold: 5
                        )
                    .offset(x: 0)
                } else if selectedKey == 0 {
                    ZStack(alignment: .top) {
                        ForEach(0..<20) { i in
                            // 100 30 0
                            Wave(strength: waveStrength, frequency: waveFrequency, phase: phase)
                                .stroke(Color.gray.opacity(Double(i) / 10), lineWidth: CGFloat(audioPulse))
                                .offset(y: CGFloat(i) * 15)
                        }
                    }
                    .onAppear {
                        withAnimation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                            self.phase = .pi * 2
                        }
                    }
                    .onDisappear {
                        self.phase = 0.0
                    }
                }

            }
            
            VStack(alignment: .leading) {
                //state 0
                if navigationState == 0 {
                    TrackScrollList(currentTime: $currentTime, soundSamples: $soundSamples, navigationState: $navigationState, tracks: tracks, selectedKey: $selectedKey)
                        //.transition(.asymmetric(insertion: .opacity, removal: .scale(scale: 0.0, anchor: .center)))
                        .transition(AnyTransition.identity)
                } else if navigationState == 1 {
                    //state 1
                    
                    CorridorView(currentIndex: $selectedKey) {
                        ForEach(0..<12) { value in
                            SlidingEntry(doorIndex: value, tracks: tracks, soundSamples: $soundSamples, currentTime: $currentTime, slideOpen: $slideOpen, selectedKey: $selectedKey, keyDragId: $keyDragId)
                        }
                    }
                    //.transition(.asymmetric(insertion: .opacity, removal: .scale(scale: 0.0, anchor: .center)))
                    //.transition(AnyTransition.identity)
                    //.offset(y: -65)
/*
                    keyGrid(navigationState: $navigationState, selectedKey: $selectedKey, slideOpen: $slideOpen, allKeys: $allKeys, keyDragId: $keyDragId)
                        .offset(y: -40)
                        .transition(AnyTransition.identity)
 */
 


                }

                SubStateController(selectedKey: $selectedKey, slideOpen: $slideOpen, allKeys: $allKeys)
                StateNavigation(navigationState: $navigationState, slideOpen: $slideOpen, selectedKey: $selectedKey, allKeys: $allKeys)
                HStack {
                    Spacer()
                    Text("\(currentTime)")
                        .font(.custom("DIN Condensed Bold", size: 16))
                        .foregroundColor(Color.gray)
                    Spacer()
                        .frame(width: 20)
                }

            }
            .offset(x: 0, y: -30)
            .animation(.default)
            .onChange(of: selectedKey) { newKey in
                subStatePlayer.playTrack(track: tracks[newKey].fileName)
            }
            .onChange(of: subStatePlayer.trackTime) { newTime in
                currentTime = newTime
            }
            .onChange(of: subStatePlayer.soundSamples) { samples in
                soundSamples = samples
            }
            .onChange(of: subStatePlayer.audioPulse) { pulse in
                audioPulse = pulse
                //phase = Double(pulse)
                waveStrength = Double(pulse*4)
                //waveFrequency = Double(pulse)
            }
            .onAppear {
                //set json
                //tracks = tracksData
                
                //store state eventually instead of starting at 0
                subStatePlayer.playTrack(track: tracks[0].fileName)
                

                
            }
            
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

    }
}

struct TrackScrollList: View, NormalizeSound {
    @Binding var currentTime: String
    @Binding var soundSamples: [Float]
    @Binding var navigationState: Int
    var tracks: [Tracks]
    @Binding var selectedKey: Int
    var currentYOffset: CGFloat {
        return -((CGFloat(selectedKey) * 50) - 200)
    }
        
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.gray, .offWhite]), startPoint: .top, endPoint: .bottomTrailing))
                    .frame(width: 50, height: geometry.size.height)
                    .offset(x: 50)
                
                HStack(alignment: .top, spacing: 1) {
                    ForEach(soundSamples, id: \.self) { level in
                        SoundBarView(soundValue: self.normalizeSoundLevel(level: level), barColor: .blue, barOpacity: 0.5, barWidth: 1.0)
                    }
                }
                .offset(x: 50, y: 0)
                
                                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(tracks) { track in
                        Button(action: {
                            if let trackButtonHit = Int(track.id) {
                                selectedKey = trackButtonHit
                            }
                        }) {
                            TrackCell(selectedKey: $selectedKey, currentTime: $currentTime, track: track)
                                .id(Int(track.id))
                                //.id(UUID())
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

struct SoundBarView: View {
    var soundValue: CGFloat
    let barColor: Color
    let barOpacity: Double
    let barWidth: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(barColor)
                .frame(width: barWidth, height: soundValue)
                .opacity(barOpacity)
        }
    }
}

struct TrackCell: View {
    @Binding var selectedKey: Int
    @Binding var currentTime: String
    var track: Tracks
    let keyShapeSize: CGFloat = 25
    
    var trackId: Int {
        return Int(track.id) ?? 0
    }
    
    var trackOpacity: Double {
        if trackId == selectedKey {
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
                    if trackId == selectedKey {
                        Text("\(currentTime)")
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

struct SubStateController: View {
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var allKeys: [Any]
    
    let buttonSize: CGFloat = 25
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            Image("subStateLogo")
//                .alignmentGuide(.bottom) { d in
//                    d[.bottom] - 0
//                }

            
            if selectedKey == 0 {
                KeyOneRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            } else if selectedKey == 1 {
                KeyTwoRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            } else if selectedKey == 2 {
                KeyThreeRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            }

        }
        .offset(x: 5)
        .animation(.default)

    }
    
}

struct StateNavigation: View {
    @Binding var navigationState: Int
    @Binding var slideOpen: Bool
    @Binding var selectedKey: Int
    @Binding var allKeys: [Any]
    let buttonSize: CGFloat = 35
    
    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Button(action: {
                    navigationState = 0
                }) {
                    NavBridge(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    navigationState = 1
                }) {
                    NavCorridor(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    navigationState = 2
                }) {
                    NavLog(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Spacer()
                Button(action: {
                    if slideOpen {
                        slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            selectedKey -= 1
                            if selectedKey < 0 {
                                selectedKey = 0
                            }
                        }
                    } else {
                        slideOpen = false
                        selectedKey -= 1
                        allKeys.shuffle()
                        if selectedKey < 0 {
                            selectedKey = 0
                        }
                    }
                }) {
                    ArrowLeft(parentSize: 10)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    if slideOpen {
                        slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            selectedKey += 1
                            if selectedKey > 11 {
                                selectedKey = 11
                            }
                        }
                    } else {
                        slideOpen = false
                        selectedKey += 1
                        allKeys.shuffle()
                        if selectedKey > 11 {
                            selectedKey = 11
                        }
                    }
                }) {
                    ArrowRight(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Spacer()
                    .frame(width: 20)
            }
        }
        .offset(x: 5)
        
    }
}

struct CorridorNavigation: View {
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var allKeys: [Any]
    let buttonSize: CGFloat = 15
    
    var body: some View {
        
        HStack {
            Spacer()
            Button(action: {
                if slideOpen {
                    slideOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedKey -= 1
                        if selectedKey < 0 {
                            selectedKey = 0
                        }
                    }
                } else {
                    slideOpen = false
                    selectedKey -= 1
                    allKeys.shuffle()
                    if selectedKey < 0 {
                        selectedKey = 0
                    }
                }
            }) {
                ArrowLeft(parentSize: 12)
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
                .frame(width: 20)
            
            if selectedKey == 0 {
                KeyOneRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            } else if selectedKey == 1 {
                KeyTwoRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            } else if selectedKey == 2 {
                KeyThreeRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            }

            Spacer()
                .frame(width: 30)
            
            Button(action: {
                if slideOpen {
                    slideOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedKey += 1
                        if selectedKey > 11 {
                            selectedKey = 11
                        }
                    }
                } else {
                    slideOpen = false
                    selectedKey += 1
                    allKeys.shuffle()
                    if selectedKey > 11 {
                        selectedKey = 11
                    }
                }
            }) {
                ArrowRight(parentSize: 12)
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
        }
        .animation(.default)
    }
    
}


struct keyGrid: View {
    let keySize: CGFloat = 10
    let keyBGSize: CGFloat = 50
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var navigationState: Int
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    
    @Binding var allKeys: [Any]
    
    @Binding var keyDragId: Int
    
    @State var rotation: Angle = Angle(degrees: 0)
    
    var body: some View {
        
        LazyVGrid(columns: gridItemLayout, spacing: 45) {
            
            ForEach(0..<allKeys.count) { index in
                self.buildKeyView(keys: self.allKeys, index: index)
            }

        }
        //maybe a bug
        //.animation(.default)}

    }
    
    func buildKeyView(keys: [Any], index: Int) -> AnyView {
        switch keys[index].self {
        case is KeyOne.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyOne(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .rotationEffect(rotation)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    
                    return withAnimation(repeated) {
                        self.rotation = Angle(degrees: 180)

                    }
                }
                .onDrag {
                    
                    keyDragId = 0
                    
                    return NSItemProvider()
                }
                
                /*
                .offset(offset1)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset1 = gesture.translation
                        }
                        .onEnded { _ in
                            offset1 = CGSize.zero
                            
                        }
                )
 */
            )
        case is KeyTwo.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyTwo(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 1
                    return NSItemProvider()
                }
            )
        case is KeyThree.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyThree(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 2
                    return NSItemProvider()
                }
            )
        case is KeyFour.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyFour(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 3
                    return NSItemProvider()
                }
            )
        case is KeyFive.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyFive(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 4
                    return NSItemProvider()
                }
            )
        case is KeySix.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeySix(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 5
                    return NSItemProvider()
                }
            )
        case is KeySeven.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeySeven(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 6
                    return NSItemProvider()
                }
            )
        case is KeyEight.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyEight(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 7
                    return NSItemProvider()
                }
            )
        case is KeyNine.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyNine(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 8
                    return NSItemProvider()
                }
            )
        case is KeyTen.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyTen(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 9
                    return NSItemProvider()
                }
            )
        case is KeyEleven.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyEleven(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 10
                    return NSItemProvider()
                }
            )
        case is KeyTwelve.Type:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyTwelve(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
                .onDrag {
                    
                    keyDragId = 11
                    return NSItemProvider()
                }

            )
        default:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.clear)
                        .keyBGShapeStyle(parentSize: keyBGSize)
                    KeyOne(parentSize: keySize)
                        .foregroundColor(.gray)
                        .frame(width: keySize, height: keySize)
                        .transition(.scale)
                }
            )
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.black)))
                                
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.clear)))
                            )
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                                
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                    }
                }
            )
    }
}

struct SquareButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat = 9
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .contentShape(Rectangle())
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.offWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.gray, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.clear, Color.black)))
                                          
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.white, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.black, Color.clear)))
                                          
                            )
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.offWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.black, Color.clear)))
                                          
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.clear, Color.black)))
                                          
                            )
                    }
                }
            )
    }
}

struct SlidingEntry: View {
    let doorIndex: Int
    var tracks: [Tracks]
    @Binding var soundSamples: [Float]
    @Binding var currentTime: String
    @Binding var slideOpen: Bool
    @Binding var selectedKey: Int
    @Binding var keyDragId: Int
    
    var body: some View {
        GeometryReader { geometry in

            VStack {
                ZStack {
                    if slideOpen {
                        LogEntry(track: tracks[selectedKey])
                    }

                    LeftDisplayDoor(doorIndex: doorIndex, currentTime: $currentTime, tracks: tracks, soundSamples: $soundSamples)
                        .offset(x: (slideOpen && selectedKey == doorIndex) ? -(geometry.size.width*0.60) : 0)
                        //.animation(Animation.easeInOut(duration: 0.4).delay(0.2))
                        .animation(Animation.easeInOut(duration: 0.4))
                    RightKeyDoor(slideOpen: $slideOpen, keyDragId: $keyDragId, selectedKey: $selectedKey, soundSamples: $soundSamples)
                        .offset(x: (slideOpen && selectedKey == doorIndex) ? geometry.size.width*0.35 : 0)
                        .animation(Animation.easeInOut(duration: 0.4))
                }
                .gesture(
                    DragGesture()
                        .onEnded {
                            if slideOpen == false {
                                if $0.startLocation.x < $0.location.x {
                                    if selectedKey > 0 {
                                        selectedKey -= 1
                                    }
                                } else if $0.startLocation.x > $0.location.x {
                                    if selectedKey < 11 {
                                        selectedKey += 1
                                    }
                                }
                            }
                        }
                )
                if !slideOpen {
                    Button(action: {
                        slideOpen = true
                    }) {
//                        Text("Enter Log Entry")
//                            .font(.custom("DIN Condensed Bold", size: 21))
//                            .foregroundColor(Color.gray)
                        ArrowRight(parentSize: 12)
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(SquareButtonStyle())
                    Spacer()
                        .frame(height: 50)
                }
            }
        }
    }
}

struct LogEntry: View {
    var track: Tracks
    @State private var entryText = "Enter Log"
    
    
    var body: some View {
        VStack {
            HStack {
                Image(track.vinylFile)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(x: 0)
                Spacer()
                    .frame(width: 20)
                Text("Log Entry For \(track.song)")
                    .font(.custom("DIN Condensed Bold", size: 18))
                    .foregroundColor(Color.gray)
            }
            Text("Song background info, \nstreaming options, \nbandcamp, etc")
                .font(.custom("DIN Condensed Bold", size: 14))
                .foregroundColor(Color.gray)
                .lineLimit(nil)
            TextEditor(text: $entryText)
                .font(.custom("DIN Condensed Bold", size: 12))
                .foregroundColor(Color.black)
                .background(Color.clear)
                .border(Color.black, width: 4)
                .lineSpacing(5)
                .padding()
                .frame(width: 200, height: 300)
            Spacer()
                .frame(height: 40)
            Button(action: {
                debugPrint("save me")
            }) {
                Text("Save")
                    .font(.custom("DIN Condensed Bold", size: 18))
                    .foregroundColor(Color.gray)
            }
            
            
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}


struct HallwayTrack: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(.white)
                .raisedShapeStyle()
                .frame(width: geometry.size.width+40, height: 277, alignment: .topLeading)
                .offset(x: 0, y: 93)
        }
    }
}

struct LeftDisplayDoor: View, NormalizeSound {
    
    let doorIndex: Int
    @Binding var currentTime: String
    var tracks: [Tracks]
    @Binding var soundSamples: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                LeftDisplayBackPlateRaw()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width*0.70, height: 400)
/*
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(soundSamples, id: \.self) { level in
                        SoundBarView(soundValue: self.normalizeSoundLevel(level: level, height: 100), barColor: .gray, barOpacity: 1.0, barWidth: 1.0)
                    }
                }
                .offset(x: -70, y: -180)
 */
                
                VStack(alignment: .leading) {
                    DoorIdPanel(doorIndex: doorIndex, currentTime: $currentTime, soundSamples: $soundSamples)
                        .frame(width: 110, height: 40, alignment: .bottomLeading)
                        //.offset(x: -50, y: -142)
                    SongInfoPanel(doorIndex: doorIndex, tracks: tracks)
                        .frame(width: 140, height: 50, alignment: .bottomLeading)
                        .offset(x: 5, y: 35)
                }
                .offset(x: -40, y: -75)

            }
        }
    }
}


struct KeyDragDropDelegate: DropDelegate {
    @Binding var keyDragId: Int
    @Binding var slideOpen: Bool
    @Binding var selectedKey: Int
    
    func performDrop(info: DropInfo) -> Bool {
        print("peform drop ", keyDragId)
        if selectedKey == keyDragId {
            slideOpen = true
        } else {
            slideOpen = false
        }

        return true
    }
}



struct RightKeyDoor: View {
    @Binding var slideOpen: Bool
    @Binding var keyDragId: Int
    @Binding var selectedKey: Int
    @Binding var soundSamples: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RightBackPlateRaw()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width*0.30, height: 400)
                    .offset(x: geometry.size.width*0.70)

                UnlockCirclePanel(slideOpen: $slideOpen)
                    .rotationEffect(.degrees(slideOpen ? 90 : 0))
                    .frame(width: 40, height: 40)
                    .offset(x: (geometry.size.width/2)-20, y: 50)


                KeyDropPanel(selectedKey: $selectedKey, slideOpen: $slideOpen, soundSamples: $soundSamples)
                    .frame(width: 80, height: 80)
                    .offset(x: (geometry.size.width*0.70)-14, y: 130)
                    /*
                    .onDrop(
                        of: [KeyDrag.keyDragIdentifier],
                        delegate: KeyDragDropDelegate(keyDragId: $keyDragId, slideOpen: $slideOpen, selectedKey: $selectedKey)
                    )
 */

            }
        }
    }
}

struct LeftDisplayBackPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 5, y: 180))
            path.addLine(to: CGPoint(x: 5, y: rect.height-40))
            path.addLine(to: CGPoint(x: 60, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width-80, y: (rect.height/2)+80))
            path.addLine(to: CGPoint(x: rect.width-80, y: (rect.height/2)+20))
            path.addLine(to: CGPoint(x: rect.width, y: 180))
            path.addLine(to: CGPoint(x: rect.width, y: 140))
            path.addLine(to: CGPoint(x: 60, y: 140))
            path.closeSubpath()
        }
    }
}

// View modifieres

struct RaisedShape: ViewModifier {
    func body(content: Content) -> some View {
            return RoundedRectangle(cornerRadius: 7)
                        .fill(Color.offWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 8)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.clear, Color.black)))
                                      
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.white, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.black, Color.clear)))
                                      
                        )
    }
}

struct LoweredShape: ViewModifier {
    func body(content: Content) -> some View {
            return RoundedRectangle(cornerRadius: 7)
                //.fill(Color.offWhite)
                .fill(Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        //.stroke(Color.gray, lineWidth: 4)
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.black, Color.clear)))
                              
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        //.stroke(Color.white, lineWidth: 8)
                        .stroke(Color.offWhite, lineWidth: 8)
                        .blur(radius: 4)
                        .offset(x: -2, y: -2)
                        .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.clear, Color.black)))
                              
                )
    }
}

struct KeyBGShape: ViewModifier {
    let parentSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.offWhite)
                    .frame(width: parentSize, height: parentSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.black, Color.clear)))
                                  
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.white, lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(RoundedRectangle(cornerRadius: 7).fill(LinearGradient(Color.clear, Color.black)))
                                  
                    )
            )
    }
}

struct CircleDepth: ViewModifier {
    func body(content: Content) -> some View {
        return Circle()
            .fill(Color.offWhite)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
            )
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 3)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
            )
    }
}

struct HardTransitionModifier: ViewModifier {
    let opacity: Double
    
    func body(content: Content) -> some View {
        content.opacity(opacity)
    }
}

struct SoftTransitionModifier: ViewModifier {
    let opacity: Double
    let animation: Animation?
    
    func body(content: Content) -> some View {
        content.opacity(opacity).animation(animation)
    }
}

struct SlideTransitionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.transition(.slide)
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

// Extensions

extension View {
    func raisedShapeStyle() -> some View {
        self.modifier(RaisedShape())
    }
    func loweredShapeStyle() -> some View {
        self.modifier(LoweredShape())
    }
    func circleDepthStyle() -> some View {
        self.modifier(CircleDepth())
    }
    func keyBGShapeStyle(parentSize: CGFloat) -> some View {
        self.modifier(KeyBGShape(parentSize: parentSize))
    }
}

extension AnyTransition {
    static var hardTransition: AnyTransition { get {
        AnyTransition.modifier(
            active: HardTransitionModifier(opacity: 1),
            identity: HardTransitionModifier(opacity: 1))
        }
    }
    
    static var softTransition: AnyTransition { get {
        AnyTransition.modifier(
            active: SoftTransitionModifier(opacity: 0, animation: nil),
            identity: SoftTransitionModifier(opacity: 1, animation: Animation.easeOut(duration: 0.5).delay(0.5)))
        }
    }
    
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
    
    static var slideTransition: AnyTransition { get {
        AnyTransition.modifier(
            active: SlideTransitionModifier(),
            identity: SlideTransitionModifier())
        }
    }
    
}

struct UnlockCirclePanel: View {
    @Binding var slideOpen: Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                slideOpen.toggle()
            }) {
                Circle()
                    .foregroundColor(.offWhite)
                    .circleDepthStyle()
                UnlockHalfCircle()
                    .foregroundColor(.gray)
                    .opacity(0.8)
            }

            
        }
    }
}

struct UnlockHalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.height/2), radius: 15, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        }
    }
}

struct KeyDropPanel: View, NormalizeSound {
    
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var soundSamples: [Float]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                KeyDropPlateRaw()
                    .foregroundColor(.gray)
                    .loweredShapeStyle()

                if selectedKey == 0 && !slideOpen {
                    Image("metalA")
                        .frame(width: geometry.size.width/3, height: geometry.size.height/3)
                        .mask(KeyOneRaw())
                        .blendMode(.lighten)
                        .opacity(0.3)
                        .shadow(radius: 5)
                        .transition(.asymmetric(insertion: .softTransition, removal: .hardTransition))
                        //.transition(AnyTransition.identity)

                } else if selectedKey == 1 && !slideOpen {
                    Image("metalA")
                        .frame(width: geometry.size.width/3, height: geometry.size.height/3)
                        .mask(KeyTwoRaw())
                        .blendMode(.lighten)
                        .opacity(0.3)
                        .shadow(radius: 5)
                        .transition(.asymmetric(insertion: .softTransition, removal: .hardTransition))
                        //.transition(AnyTransition.identity)
 
                } else if selectedKey == 2 && !slideOpen {
                    Image("metalA")
                        .frame(width: geometry.size.width/3, height: geometry.size.height/3)
                        .mask(KeyThreeRaw())
                        .blendMode(.lighten)
                        .opacity(0.3)
                        .shadow(radius: 5)
                        .transition(.asymmetric(insertion: .softTransition, removal: .hardTransition))
                        //.transition(AnyTransition.identity)
 
 
                }
            }
        }
    }
}

struct DoorIdPanel: View, NormalizeSound {
    let doorIndex: Int
    @Binding var currentTime: String
    @Binding var soundSamples: [Float]
    
    var formattedIndex: String {
        return (doorIndex < 10) ? "0\(doorIndex)" : "\(doorIndex)"
    }
    
    var body: some View {
        ZStack {
            DoorIdPlateRaw()
                .foregroundColor(.gray)
                .loweredShapeStyle()
            /*
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(soundSamples, id: \.self) { level in
                    SoundBarView(soundValue: self.normalizeSoundLevel(level: level, height: 25), barColor: .white, barOpacity: 0.8, barWidth: 1.0)
                }
            }
            .offset(x: 0, y: 14)
            .scaleEffect(x: 4, anchor: .center)
 */
            Text("\(currentTime)")
                //.font(.system(size: 50))
                .font(.custom("DIN Condensed Bold", size: 20))
                .foregroundColor(.offWhite)
                .offset(y: 8)
        }
    }
}

struct SongInfoPanel: View {
    let doorIndex: Int
    var tracks: [Tracks]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("\(tracks[doorIndex].song)")
                    .font(.custom("DIN Condensed Bold", size: 16))
                    .foregroundColor(.gray)
                Text("\(tracks[doorIndex].artist)")
                    .font(.custom("DIN Condensed Bold", size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}
struct DoorIdPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
        }
    }
}

struct KeyDropPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
        }
    }
}

struct RightBackPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 3, y: 140))
            path.addLine(to: CGPoint(x: 3, y: 182))
            path.addLine(to: CGPoint(x: -77, y: (rect.height/2)+22))
            path.addLine(to: CGPoint(x: -77, y: (rect.height/2)+79))
            path.addLine(to: CGPoint(x: 3, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width-25, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width-5, y: rect.height-25))
            path.addLine(to: CGPoint(x: rect.width-5, y: 165))
            path.addLine(to: CGPoint(x: rect.width-25, y: 140))
            path.closeSubpath()
        }
    }
}

struct ArrowLeft: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct ArrowRight: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .scale(x: -1)
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct ArrowRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height/2)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: rect.height/2))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.height + (rect.height/2)))
            path.closeSubpath()
        }
    }
}

// bridge corriodr log

struct NavBridge: View {
    var parentSize: CGFloat
    
    var body: some View {
        VStack {
            BridgeRaw()
                .frame(width: parentSize, height: parentSize)
                .offset(y: 5)
        }
    }
}

struct NavCorridor: View {
    var parentSize: CGFloat
    
    var body: some View {
        HStack(spacing: 2) {
            Rectangle()
                .frame(width: parentSize, height: parentSize)
            Rectangle()
                .frame(width: parentSize, height: parentSize)
            Rectangle()
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct NavLog: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct BridgeRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-3)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-3)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-6)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-6)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-9)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-9)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-12)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-12)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-15)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-15)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-21)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-21)))
            path.closeSubpath()
        }
    }
}

struct CorridorRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height/2)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: rect.height/2))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.height + (rect.height/2)))
            path.closeSubpath()
        }
    }
}

struct LogRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-21)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-21)))
            path.closeSubpath()
        }
    }
}








