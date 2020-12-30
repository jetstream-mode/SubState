//
//  ContentView.swift
//  keyOneShapesTest
//
//  Created by Josh Kneedler on 8/5/20.
//

import SwiftUI

extension SubState {
    struct Screen: View {
        //Player relies on 2 state objects
        @StateObject var evaluator: Evaluator
        @StateObject var subStatePlayer = SubStatePlayer()
        
        init(evaluator: Evaluator = .init()) {
            _evaluator = StateObject(wrappedValue: evaluator)
        }
        
        var body: some View {
            ZStack {
                Color.offWhite
                
                VStack(alignment: .leading) {
                    if evaluator.navId == 0 {
                        TrackScrollList(evaluator: evaluator, subStatePlayer: subStatePlayer)
                            .transition(AnyTransition.identity)
                    } else if evaluator.navId == 1 {
                        CorridorView(evaluator: evaluator) {
                            ForEach(0..<12) { value in
                                SlidingEntry(evaluator: evaluator, subStatePlayer: subStatePlayer, doorIndex: value)
                            }
                        }
                    } else if evaluator.navId == 2 {
                        LogList(evaluator: evaluator)
                    }

                    SubStateController(evaluator: evaluator)
                    
                    StateNavigation(evaluator: evaluator)

                    HStack {
                        Spacer()
                        Text("\(subStatePlayer.trackTime)")
                            .font(.custom("DIN Condensed Bold", size: 16))
                            .foregroundColor(Color.gray)
                        Spacer()
                            .frame(width: 20)
                    }

                }
                .offset(x: 0, y: -30)
                .animation(.default)
                .onChange(of: evaluator.selectedKey) { newKey in
                    evaluator.playPause = true
                    subStatePlayer.playTrack(track: evaluator.tracks[newKey].fileName)
                }
                .onChange(of: subStatePlayer.songComplete) { songComplete in
                    if songComplete {
                        if evaluator.selectedKey < 11 {
                            evaluator.selectedKey += 1
                            subStatePlayer.playTrack(track: evaluator.tracks[evaluator.selectedKey].fileName)
                        }
                    }
                }
                .onChange(of: evaluator.playPause) { pp in
                    
                    if !pp {
                        subStatePlayer.pausePlayer()
                        evaluator.playerTime = subStatePlayer.audioPlayer.currentTime
                        UserDefaults.standard.set(evaluator.playerTime, forKey: "atsatime")
                        UserDefaults.standard.set(evaluator.selectedKey, forKey: "savedkey")
                        UserDefaults.standard.set(evaluator.playPause, forKey: "playpause")
                    } else {
                        subStatePlayer.resumePlayer()
                        UserDefaults.standard.set(evaluator.playPause, forKey: "playpause")
                    }
                    
                }
                .onAppear {
                    debugPrint("first appear")
                    evaluator.playPause = true
                    subStatePlayer.playTrack(track: evaluator.tracks[evaluator.selectedKey].fileName, playHead: evaluator.playerTime)
                    
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to the background!")
                evaluator.playerTime = subStatePlayer.audioPlayer.currentTime
                UserDefaults.standard.set(evaluator.playerTime, forKey: "atsatime")
                UserDefaults.standard.set(evaluator.selectedKey, forKey: "savedkey")
                UserDefaults.standard.set(evaluator.navId, forKey: "navId")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground!")
                if evaluator.playPause {
                    subStatePlayer.playTrack(track: evaluator.tracks[evaluator.selectedKey].fileName, playHead: evaluator.playerTime)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                print("App will quit")
                evaluator.playerTime = subStatePlayer.audioPlayer.currentTime
                UserDefaults.standard.set(evaluator.playerTime, forKey: "atsatime")
                UserDefaults.standard.set(evaluator.selectedKey, forKey: "savedkey")
                UserDefaults.standard.set(evaluator.navId, forKey: "navId")
            }
        }
    }
}


struct LogList: View {
    @StateObject var evaluator: Evaluator
    @State var logDisplayItems: [LogEntryData] = []

    
    init(evaluator: Evaluator = .init()) {
        _evaluator = StateObject(wrappedValue: evaluator)
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
                    ForEach(logDisplayItems, id: \.id) { log in
                        LogCellView(logEntry: log)
                    }
                }
            }
        }
        .onAppear {
            logDisplayItems = evaluator.logEntries.displayItems()
        }
    }
    
    func delete(at offsets: IndexSet) {
        evaluator.logEntries.removeItem(at: offsets)
    }
}
struct LogCellButtonStyle: ButtonStyle {
    let height: CGFloat = 60
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
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
    
    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer
    
    let doorIndex: Int

    
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .trailing) {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    if evaluator.slideOpen {
                        BehindClosedDoor(evaluator: evaluator)
                            .zIndex(1)
                    }
                    LeftDisplayDoor(evaluator: evaluator, subStatePlayer: subStatePlayer, doorIndex: doorIndex)
                        .offset(x: (evaluator.slideOpen && evaluator.selectedKey == doorIndex) ? -(geometry.size.width*0.60) : 0)
                        .animation((evaluator.slideOpen && evaluator.selectedKey == doorIndex) ? Animation.easeIn(duration: 0.4) : Animation.easeOut(duration: 0.4))
                        .zIndex(2)
                    RightKeyDoor(evaluator: evaluator, subStatePlayer: subStatePlayer)
                        .offset(x: (evaluator.slideOpen && evaluator.selectedKey == doorIndex) ? geometry.size.width*0.35 : 0)
                        .animation((evaluator.slideOpen && evaluator.selectedKey == doorIndex) ? Animation.easeIn(duration: 0.4) : Animation.easeOut(duration: 0.4))
                        .zIndex(3)
                }
                .gesture(
                    DragGesture()
                        .onEnded {
                            if evaluator.slideOpen == false {
                                if $0.startLocation.x < $0.location.x {
                                    if evaluator.selectedKey > 0 {
                                        evaluator.selectedKey -= 1
                                    }
                                } else if $0.startLocation.x > $0.location.x {
                                    if evaluator.selectedKey < 11 {
                                        evaluator.selectedKey += 1
                                    }
                                }
                            }
                        }
                )
                if !evaluator.slideOpen {
                    Button(action: {
                        evaluator.slideOpen = true
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
    @StateObject var evaluator: Evaluator

    @State private var entryText = "_"
    @State private var saveButtonHeight = CGFloat(20)

    var leftMargin = CGFloat(40)

    @State var leftSlideMargin = CGFloat(40)
    @State var rightSlideMargin = CGFloat(40)
    @State var scaleY: CGFloat = 0
    @State var alphaRow: Double = 0
    
    
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                    .frame(height: 137)
                BehindDoorSave(evaluator: evaluator, entryText: $entryText, saveButtonHeight: $saveButtonHeight)
                    .offset(x: leftSlideMargin)
                    .frame(width: (geometry.size.width - leftMargin*2)-0, height: saveButtonHeight)
                    .opacity(alphaRow)
                BehindDoorLogEntry(entryText: $entryText)
                    .offset(x: rightSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-0, height: 100)
                    .opacity(alphaRow)
                    .scaleEffect(scaleY, anchor: .bottom)
                BehindDoorVinylAndAction(track: evaluator.tracks[evaluator.selectedKey])
                    .offset(x: leftSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-20, height: 50)
                    .opacity(alphaRow)
                BehindDoorArtistSong(track: evaluator.tracks[evaluator.selectedKey])
                    .offset(x: rightSlideMargin, y: 14)
                    .frame(width: (geometry.size.width - leftMargin*2)-5, height: 50)
                    .opacity(alphaRow)
                BehindDoorSongHistory(track: evaluator.tracks[evaluator.selectedKey])
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
    @StateObject var evaluator: Evaluator
    
    @Binding var entryText: String
    @Binding var saveButtonHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                let loggedDataStamp = "Log Entry: \(Date().description)"
                let logData = LogEntryData(loggedTrack: evaluator.tracks[evaluator.selectedKey], loggedUserText: entryText, loggedDate: loggedDataStamp)
                evaluator.logEntries.add(item: logData)
                self.hideKeyboard()
                evaluator.slideOpen = false
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
    
    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer
    
    let doorIndex: Int
    
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
                    DoorIdPanel(subStatePlayer: subStatePlayer, doorIndex: doorIndex)
                        .frame(width: 110, height: 40, alignment: .bottomLeading)
                    SongInfoPanel(doorIndex: doorIndex, tracks: evaluator.tracks)
                        .frame(width: 140, height: 50, alignment: .bottomLeading)
                        .offset(x: 5, y: 35)

                }
                .offset(x: -40, y: -75)

            }
        }
    }
}

struct RightKeyDoor: View {
    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer
        
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
                

                UnlockCirclePanel(evaluator: evaluator)
                    .rotationEffect(.degrees(evaluator.slideOpen ? 90 : 0))
                    .frame(width: 40, height: 40)
                    .offset(x: (geometry.size.width/2)-20, y: -175)


                KeyDropPanel(evaluator: evaluator, subStatePlayer: subStatePlayer)
                    .frame(width: 80, height: 80)
                    .offset(x: (geometry.size.width*0.70)-14, y: -50)

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
                .fill(Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(RoundedRectangle(cornerRadius: 0).fill(LinearGradient(Color.black, Color.clear)))
                              
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
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
    @StateObject var evaluator: Evaluator
    
    var body: some View {
        ZStack {
            Button(action: {
                evaluator.slideOpen.toggle()
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
    @StateObject var evaluator: Evaluator
    @StateObject var subStatePlayer: SubStatePlayer

    @State private var endShapeAmount: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                KeyDropPlateRaw()
                    .foregroundColor(.gray)
                    .loweredShapeStyle()

                if evaluator.selectedKey == 0 && !evaluator.slideOpen {
                    Image("metalA")
                        .frame(width: geometry.size.width/3, height: geometry.size.height/3)
                        .mask(KeyOneRaw())
                        .blendMode(.lighten)
                        .opacity(0.3)
                        .shadow(radius: 5)
                        .transition(.asymmetric(insertion: .softTransition, removal: .hardTransition))

                } else if evaluator.selectedKey == 1 && !evaluator.slideOpen {
                    Image("metalA")
                        .frame(width: geometry.size.width/3, height: geometry.size.height/3)
                        .mask(KeyTwoRaw())
                        .blendMode(.lighten)
                        .opacity(0.3)
                        .shadow(radius: 5)
                        .transition(.asymmetric(insertion: .softTransition, removal: .hardTransition))
                        //.transition(AnyTransition.identity)
 
                } else if evaluator.selectedKey == 2 && !evaluator.slideOpen {
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
    @StateObject var subStatePlayer: SubStatePlayer
    let doorIndex: Int
    
    var formattedIndex: String {
        return (doorIndex < 10) ? "0\(doorIndex)" : "\(doorIndex)"
    }
    
    var body: some View {
        ZStack {
            DoorIdPlateRaw()
                .foregroundColor(.gray)
                .loweredShapeStyle()

            Text("\(subStatePlayer.trackTime)")
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif








