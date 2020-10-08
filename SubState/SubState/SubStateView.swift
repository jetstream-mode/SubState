//
//  ContentView.swift
//  keyOneShapesTest
//
//  Created by Josh Kneedler on 8/5/20.
//

import Poet
import SwiftUI

struct SubStateView {}

extension SubStateView {
    
    struct Screen: View {
        
        typealias Action = Evaluator.Action
        
        let evaluator: Evaluator
        let translator: Translator
        
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
        @State var selectedKey: Int = UserDefaults.standard.integer(forKey: "savedkey")
        @State var slideOpen: Bool = false
        @State var allKeys: [Any] = [KeyOne.self, KeyTwo.self, KeyThree.self, KeyFour.self, KeyFive.self, KeySix.self, KeySeven.self, KeyEight.self, KeyNine.self, KeyTen.self, KeyEleven.self, KeyTwelve.self]
        
        @State var keyDragId: Int = 0
        
        //save this on evaluator
        //@State var navigationState: Int = UserDefaults.standard.integer(forKey: "navstate")
        
        @State var playPause: Bool = UserDefaults.standard.bool(forKey: "playpause")
        
        @State var playerTime: TimeInterval = UserDefaults.standard.double(forKey: "atsatime")
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        

        var body: some View {
            ZStack {
                Color.offWhite
                //if navigationState == 1 && slideOpen {
                if translator.navId == 1 && slideOpen {

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
                    if translator.navId == 0 {
                        TrackScrollList(currentTime: $currentTime, soundSamples: $soundSamples, tracks: tracks, selectedKey: $selectedKey)
                            //.transition(.asymmetric(insertion: .opacity, removal: .scale(scale: 0.0, anchor: .center)))
                            .transition(AnyTransition.identity)
                    } else if translator.navId == 1 {
                        //state 1
                        
                        CorridorView(currentIndex: $selectedKey) {
                            ForEach(0..<12) { value in
                                SlidingEntry(doorIndex: value, tracks: tracks, soundSamples: $soundSamples, currentTime: $currentTime, slideOpen: $slideOpen, selectedKey: $selectedKey, keyDragId: $keyDragId)
                            }
                        }

                    } else if translator.navId == 2 {
                        //log state
                        LogList()
                    }

                    SubStateController(selectedKey: $selectedKey, slideOpen: $slideOpen, allKeys: $allKeys)
                    //StateNavigation(navigationState: $navigationState, slideOpen: $slideOpen, selectedKey: $selectedKey, allKeys: $allKeys, playPause: $playPause)
                    StateNavigation(evaluator: evaluator, slideOpen: $slideOpen, selectedKey: $selectedKey, playPause: $playPause)
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
                    playPause = true
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
                .onChange(of: subStatePlayer.songComplete) { songComplete in
                    if songComplete {
                        if selectedKey < 11 {
                            selectedKey += 1
                            subStatePlayer.playTrack(track: tracks[selectedKey].fileName)
                        }
                    }
                }
                .onChange(of: playPause) { pp in
                    
                    if !pp {
                        subStatePlayer.pausePlayer()
                        playerTime = subStatePlayer.audioPlayer.currentTime
                        UserDefaults.standard.set(playerTime, forKey: "atsatime")
                        UserDefaults.standard.set(selectedKey, forKey: "savedkey")
                        UserDefaults.standard.set(playPause, forKey: "playpause")
                    } else {
                        //subStatePlayer.playTrack(track: tracks[selectedKey].fileName, playHead: playerTime)
                        subStatePlayer.resumePlayer()
                        UserDefaults.standard.set(playPause, forKey: "playpause")
                    }
                    
                }
                .onAppear {
                    debugPrint("first appear")
                    playPause = true
                    subStatePlayer.playTrack(track: tracks[selectedKey].fileName, playHead: playerTime)
                    
                }
                
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to the background!")
                playerTime = subStatePlayer.audioPlayer.currentTime
                UserDefaults.standard.set(playerTime, forKey: "atsatime")
                UserDefaults.standard.set(selectedKey, forKey: "savedkey")
                //UserDefaults.standard.set(navigationState, forKey: "navstate")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground!")
                if playPause {
                    subStatePlayer.playTrack(track: tracks[selectedKey].fileName, playHead: playerTime)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                print("App will quit")
                playerTime = subStatePlayer.audioPlayer.currentTime
                UserDefaults.standard.set(playerTime, forKey: "atsatime")
                UserDefaults.standard.set(selectedKey, forKey: "savedkey")
                //UserDefaults.standard.set(navigationState, forKey: "navstate")
            }
        }
    }
}



struct LogList: View {
    @ObservedObject var logEntries = LogEntries()

    
    init() {
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().backgroundColor = UIColor(Color.offWhite)
    }
    
    /*
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
     //need scrollview
     */
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            Text("Log Entries")
                .font(.custom("DIN Condensed Bold", size: 24))
                .foregroundColor(Color.gray)
            /*
            List {
                ForEach(logEntries.displayItems(), id: \.id) { log in
                    LogCellView(logEntry: log)
                }
                .onDelete(perform: delete)
                .listRowBackground(Color.white)
                .animation(.default)
                
            }
 */
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(logEntries.displayItems(), id: \.id) { log in
                        LogCellView(logEntry: log)
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        logEntries.removeItem(at: offsets)
    }
}
struct LogCellButtonStyle: ButtonStyle {
    let height: CGFloat = 60
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            //.foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.white : Color.white)
    }
}

struct LogCellView: View {
    
    var logEntry: LogEntryData
    @State var cellHeight: CGFloat = 50
    @State private var showEntry = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(logEntry.loggedTrack.vinylFile)
                .resizable()
                .frame(width: 50, height: 50)
                .offset(x: 0)
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 10) {
                Text("\(logEntry.loggedDate)")
                    .font(.custom("DIN Condensed Bold", size: 20))
                    .foregroundColor(Color.gray)
                if showEntry {
                    Text("\(logEntry.loggedUserText)")
                        .font(.custom("DIN Condensed Bold", size: 16))
                        .foregroundColor(Color.gray)
                    HStack {
                        Image("twitter")
                            .resizable()
                            .saturation(0.0)
                            .frame(width: 25, height: 25)
                        Image("bandcamp")
                            .resizable()
                            .saturation(0.0)
                            .frame(width: 25, height: 25)
                    }
                }
            }
            Spacer()
            ArrowUp(parentSize: 6)
                .foregroundColor(.gray)
                .frame(width: 25, height: 20)
                .rotationEffect(.degrees(showEntry ? 180 : 0))
            Spacer()
                .frame(width: 20)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                self.showEntry.toggle()
            }
        }
    }
}



struct TrackScrollList: View, NormalizeSound {
    @Binding var currentTime: String
    @Binding var soundSamples: [Float]
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubStateView.Screen()
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
    let cornerRadius: CGFloat = 0
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

            VStack(alignment: .trailing) {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    if slideOpen {
                        BehindClosedDoor(track: tracks[selectedKey], slideOpen: $slideOpen)
                            .zIndex(1)
                    }
                    LeftDisplayDoor(doorIndex: doorIndex, currentTime: $currentTime, tracks: tracks, soundSamples: $soundSamples)
                        .offset(x: (slideOpen && selectedKey == doorIndex) ? -(geometry.size.width*0.60) : 0)
                        .animation((slideOpen && selectedKey == doorIndex) ? Animation.easeIn(duration: 0.4) : Animation.easeOut(duration: 0.4))
                        .zIndex(2)
                    RightKeyDoor(slideOpen: $slideOpen, keyDragId: $keyDragId, selectedKey: $selectedKey, soundSamples: $soundSamples)
                        .offset(x: (slideOpen && selectedKey == doorIndex) ? geometry.size.width*0.35 : 0)
                        .animation((slideOpen && selectedKey == doorIndex) ? Animation.easeIn(duration: 0.4) : Animation.easeOut(duration: 0.4))
                        .zIndex(3)
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
                        HStack {
                            ArrowUp(parentSize: 6)
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 20)
                            Text("Log Track")
                                .font(.custom("DIN Condensed Bold", size: 12))
                                .foregroundColor(Color.gray)
                        }

                    }
                    .buttonStyle(SquareButtonStyle())
                    .offset(y: 65)
                    Spacer()
                        .frame(height: 50)
                }
            }
        }
    }
}

struct BehindClosedDoor: View {
    var track: Tracks
    @Binding var slideOpen: Bool
    @State private var entryText = "_"
    @State private var saveButtonHeight = CGFloat(20)
    @EnvironmentObject var logEntries: LogEntries
    var leftMargin = CGFloat(40)
    //@State var leftSlideMargin = CGFloat(-500)
    //@State var rightSlideMargin = CGFloat(500)
    @State var leftSlideMargin = CGFloat(40)
    @State var rightSlideMargin = CGFloat(40)
    @State var scaleY: CGFloat = 0
    @State var alphaRow: Double = 0
    
    
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                    .frame(height: 137)
                BehindDoorSave(track: track, slideOpen: $slideOpen, entryText: $entryText, saveButtonHeight: $saveButtonHeight)
                    .offset(x: leftSlideMargin)
                    .frame(width: (geometry.size.width - leftMargin*2)-0, height: saveButtonHeight)
                    .opacity(alphaRow)
                BehindDoorLogEntry(entryText: $entryText)
                    .offset(x: rightSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-0, height: 100)
                    .opacity(alphaRow)
                    .scaleEffect(scaleY, anchor: .bottom)
                BehindDoorVinylAndAction(track: track)
                    .offset(x: leftSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-20, height: 50)
                    .opacity(alphaRow)
                BehindDoorArtistSong(track: track)
                    .offset(x: rightSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-5, height: 50)
                    .opacity(alphaRow)
                BehindDoorSongHistory(track: track)
                    .offset(x: leftSlideMargin, y: 5)
                    .frame(width: (geometry.size.width - leftMargin*2)-45, height: 140)
                    .opacity(alphaRow)

            }
            .animation(Animation.easeOut(duration: 0.7).delay(0))
            .onAppear {
                scaleY = 1
                alphaRow = 1
            }
        }

    }
}

struct BehindDoorSave: View {
    var track: Tracks
    @Binding var slideOpen: Bool
    @Binding var entryText: String
    @Binding var saveButtonHeight: CGFloat
    @EnvironmentObject var logEntries: LogEntries
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                let logEntry = LogEntries()
                let loggedDataStamp = "Log Entry: \(Date().description)"
                let logData = LogEntryData(loggedTrack: track, loggedUserText: entryText, loggedDate: loggedDataStamp)
                logEntry.add(item: logData)
                self.hideKeyboard()
                slideOpen = false
            }) {
                Text("Save")
                    .font(.custom("DIN Condensed Bold", size: 21))
                    .foregroundColor(Color.gray)
                    .frame(width: geometry.size.width, height: saveButtonHeight)
                    .padding(.top, 8)
                    .padding(.bottom, 5)
                
            }
            .border(Color.gray, width: 1)
            .onAppear {
                debugPrint("behind door width b ", geometry.size.width)
            }

        }
    }
}

struct BehindDoorLogEntry: View {
    
    @Binding var entryText: String
    
    var body: some View {
        GeometryReader { geometry in
            TextEditor(text: $entryText)
                .font(.custom("DIN Condensed Bold", size: 24))
                .foregroundColor(Color.gray)
                .background(Color.clear)
                .border(Color.gray, width: 1)
                .lineSpacing(5)
                .frame(width: geometry.size.width, height: 100)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
        }
    }
}

struct BehindDoorVinylAndAction: View {
    var track: Tracks
    
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                Image(track.vinylFile)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(x: 0)
                Spacer()
                    .frame(width: 20)
                HStack {
                    Text("Log Entry")
                        .font(.custom("DIN Condensed Bold", size: 32))
                        .foregroundColor(Color.gray)
                    ArrowUp(parentSize: 6)
                        .foregroundColor(.gray)
                        .frame(width: 25, height: 20)
                }
                .frame(width: geometry.size.width - 50)

            }
            .border(Color.gray, width: 1)
            
        }
    }
}
struct BehindDoorArtistSong: View {
    var track: Tracks
    
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(track.artist)")
                        .font(.custom("DIN Condensed Bold", size: 18))
                        .foregroundColor(Color.gray)
                        .frame(width: geometry.size.width, alignment: .leading)
                    Text("\(track.song)")
                        .font(.custom("DIN Condensed Bold", size: 12))
                        .foregroundColor(Color.gray)
                        .frame(width: geometry.size.width, alignment: .leading)
                }
                .padding(.leading, 5)
                .padding(.top, 7)
                .padding(.bottom, 5)

            }
            .border(Color.gray, width: 1)
            
        }
    }
}

struct BehindDoorSongHistory: View {
    var track: Tracks
    
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est test.")
                        .font(.custom("DIN Condensed Bold", size: 14))
                        .lineLimit(nil)
                        .lineSpacing(2)
                        .foregroundColor(Color.gray)
                        .frame(width: geometry.size.width, alignment: .leading)
                }
                .padding(.leading, 5)
                .padding(.top, 15)
                .padding(.bottom, 8)
                .padding(.trailing, 40)

            }
            .border(Color.gray, width: 1)
            
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
                Image("metalA")
                    .resizable()
                    .frame(width: geometry.size.width*0.70, height: 504)
                    .blur(radius: 8)
                    .mask(LeftDisplayBackPlateRaw())
                
                LeftPlateStripe()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width*0.70, height: 30)
                    .offset(x: 5, y: -10)
                    .blendMode(.softLight)

                VStack(alignment: .leading) {
                    DoorIdPanel(doorIndex: doorIndex, currentTime: $currentTime, soundSamples: $soundSamples)
                        .frame(width: 110, height: 40, alignment: .bottomLeading)
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
            ZStack(alignment: .bottom) {
                
                RightBackPlateRaw()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width*0.30, height: 504)
                    .offset(x: geometry.size.width*0.70)
                    .shadow(radius: 1)
                
                RightPlateStripe()
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width*0.30, height: 22)
                    .opacity(0.7)
                    .offset(x: geometry.size.width*0.70, y: 0)
                

                UnlockCirclePanel(slideOpen: $slideOpen)
                    .rotationEffect(.degrees(slideOpen ? 90 : 0))
                    .frame(width: 40, height: 40)
                    .offset(x: (geometry.size.width/2)-20, y: -175)


                KeyDropPanel(selectedKey: $selectedKey, slideOpen: $slideOpen, soundSamples: $soundSamples)
                    .frame(width: 80, height: 80)
                    .offset(x: (geometry.size.width*0.70)-14, y: -50)
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
            return RoundedRectangle(cornerRadius: 0)
                //.fill(Color.offWhite)
                .fill(Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        //.stroke(Color.gray, lineWidth: 4)
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(RoundedRectangle(cornerRadius: 0).fill(LinearGradient(Color.black, Color.clear)))
                              
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        //.stroke(Color.white, lineWidth: 8)
                        .stroke(Color.offWhite, lineWidth: 8)
                        .blur(radius: 4)
                        .offset(x: -2, y: -2)
                        .mask(RoundedRectangle(cornerRadius: 0).fill(LinearGradient(Color.clear, Color.black)))
                              
                )
    }
}

struct KeyBGShape: ViewModifier {
    let parentSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.offWhite)
                    .frame(width: parentSize, height: parentSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(RoundedRectangle(cornerRadius: 0).fill(LinearGradient(Color.black, Color.clear)))
                                  
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.white, lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(RoundedRectangle(cornerRadius: 0).fill(LinearGradient(Color.clear, Color.black)))
                                  
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
    @State private var endShapeAmount: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                KeyDropPlateRaw()
                    .foregroundColor(.gray)
                    .loweredShapeStyle()

                if selectedKey == 0 && !slideOpen {
                    /*
                    ShapeView(bezier: UIBezierPath.keyOneBezier)
                        .trim(from: 0, to: endShapeAmount)
                        .stroke(Color.red, lineWidth: 4)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1)) {
                                self.endShapeAmount = 1
                            }
                        }
                        .onDisappear {
                            debugPrint("bye shape 0")
                            self.endShapeAmount = 0
                        }
 */
                        

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

            Text("\(currentTime)")
                //.font(.system(size: 50))
                .font(.custom("DIN Condensed Bold", size: 20))
                .foregroundColor(.offWhite)
                .offset(y: 8)
                .blendMode(.softLight)
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
                    .foregroundColor(.white)
                Text("\(tracks[doorIndex].artist)")
                    .font(.custom("DIN Condensed Bold", size: 12))
                    .foregroundColor(.white)
            }
            .blendMode(.softLight)
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

struct LeftPlateStripe: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width*0.70, y: 0))
            path.addLine(to: CGPoint(x: rect.width*0.94, y: 17))
            path.addLine(to: CGPoint(x: rect.width*0.98, y: 40))
            path.addLine(to: CGPoint(x: rect.width*0.70, y: 4))
            path.addLine(to: CGPoint(x: 12, y: 10))
            path.closeSubpath()
        }
    }
}

struct RightPlateStripe: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: -9, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2, y: 22))
            path.addLine(to: CGPoint(x: 0, y: 22))
            path.closeSubpath()
        }
    }
}

struct ArrowLeft: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ArrowRaw()
                    .frame(width: parentSize, height: parentSize)
                ArrowRaw()
                    .frame(width: parentSize, height: parentSize)
            }
        }
    }
}

struct ArrowRight: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ArrowRaw()
                    .scale(x: -1)
                    .frame(width: parentSize, height: parentSize)
                ArrowRaw()
                    .scale(x: -1)
                    .frame(width: parentSize, height: parentSize)
            }

        }
    }
}

struct ArrowPlay: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .scale(x: -1)
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct ArrowPause: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            PauseRaw()
                .frame(width: parentSize, height: parentSize)
                .offset(y: 3)
        }
    }
}
struct ArrowUp: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .rotation(.degrees(90))
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
            Circle()
                .frame(width: parentSize, height: parentSize)
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
            LogRaw()
                .frame(width: parentSize, height: parentSize)
                .offset(y: 8)
        }
    }
}

struct BridgeRaw: Shape {
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

struct PauseRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: (rect.size.width/2)-4, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-1, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-1, y: rect.height))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-4, y: rect.height))
            path.closeSubpath()
            path.move(to: CGPoint(x: (rect.size.width/2)+1, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+4, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+4, y: rect.height))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+1, y: rect.height))
            path.closeSubpath()
        }
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif








