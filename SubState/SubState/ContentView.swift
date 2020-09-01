//
//  ContentView.swift
//  keyOneShapesTest
//
//  Created by Josh Kneedler on 8/5/20.
//

import SwiftUI

struct ContentView: View {
    let keySize: CGFloat = 25
    @State var selectedKey: Int = 0
    @State var slideOpen: Bool = false
    @State var allKeys: [Any] = [KeyOne.self, KeyTwo.self, KeyThree.self, KeyFour.self, KeyFive.self, KeySix.self, KeySeven.self, KeyEight.self, KeyNine.self, KeyTen.self, KeyEleven.self, KeyTwelve.self]
    
    @State var keyDragId: Int = 0
    
    var body: some View {
        ZStack {
            Color.offWhite
            HallwayTrack()
            VStack(alignment: .leading) {
                CorridorView(doorCount: 12, currentIndex: $selectedKey) {
                    ForEach(0..<12) { value in
                        SlidingEntry(doorIndex: value, slideOpen: $slideOpen, selectedKey: $selectedKey, keyDragId: $keyDragId)
                    }
                }
                CorridorNavigation(selectedKey: $selectedKey, slideOpen: $slideOpen, allKeys: $allKeys)
                    .offset(y: -60)
                keyGrid(selectedKey: $selectedKey, slideOpen: $slideOpen, allKeys: $allKeys, keyDragId: $keyDragId)
            }
            .offset(x: 0, y: -40)
            
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

    }
}

struct CorridorNavigation: View {

    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var allKeys: [Any]
    
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
                    .frame(width: 25, height: 25)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
                .frame(width: 20)
            
            if selectedKey == 0 {
                KeyOneRaw()
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
                    .transition(.scale)
            } else if selectedKey == 1 {
                KeyTwoRaw()
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
                    .transition(.scale)
            } else if selectedKey == 2 {
                KeyThreeRaw()
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
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
                    .frame(width: 25, height: 25)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
        }
        .animation(.default)
    }
    
}


struct keyGrid: View {
    let keySize: CGFloat = 25
    let keyBGSize: CGFloat = 75
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    
    @Binding var allKeys: [Any]
    
    @Binding var keyDragId: Int
    
    var body: some View {

        LazyVGrid(columns: gridItemLayout, spacing: 55) {
            
            ForEach(0..<allKeys.count) { index in
                self.buildKeyView(keys: self.allKeys, index: index)
            }

        }
        //maybe a bug
        //.animation(.default)
        
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
            .padding(30)
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
    
    @Binding var slideOpen: Bool
    @Binding var selectedKey: Int
    @Binding var keyDragId: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Text("Song info for: \(doorIndex)")
                        .foregroundColor(.gray)
                        .opacity(slideOpen ? 1 : 0)
                        .offset(y: 50)
                    LeftDisplayDoor(doorIndex: doorIndex)
                        .offset(x: (slideOpen && selectedKey == doorIndex) ? -(geometry.size.width*0.60) : 0)
                        //.animation(Animation.easeInOut(duration: 0.4).delay(0.2))
                        .animation(Animation.easeInOut(duration: 0.4))
                    RightKeyDoor(slideOpen: $slideOpen, keyDragId: $keyDragId, selectedKey: $selectedKey)
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
            }
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

struct LeftDisplayDoor: View {
    
    let doorIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LeftDisplayBackPlateRaw()
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width*0.70, height: 400)
                DoorIdPanel(doorIndex: doorIndex)
                    .frame(width: 110, height: 40, alignment: .topLeading)
                    .offset(x: -50, y: 38)
                SongInfoPanel(doorIndex: doorIndex)
                    .frame(width: 140, height: 50, alignment: .topLeading)
                    .offset(x: -30, y: 150)

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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RightBackPlateRaw()
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width*0.30, height: 400)
                    .offset(x: geometry.size.width*0.70)
                UnlockCirclePanel()
                    .rotationEffect(.degrees(slideOpen ? 90 : 0))
                    .frame(width: 40, height: 40)
                    .offset(x: (geometry.size.width/2)-20, y: 50)
                KeyDropPanel(selectedKey: $selectedKey, slideOpen: $slideOpen)
                    .frame(width: 80, height: 80)
                    .offset(x: (geometry.size.width*0.70)-14, y: 130)
                    .onDrop(
                        of: [KeyDrag.keyDragIdentifier],
                        delegate: KeyDragDropDelegate(keyDragId: $keyDragId, slideOpen: $slideOpen, selectedKey: $selectedKey)
                    )

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
    
}

struct UnlockCirclePanel: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.offWhite)
                .circleDepthStyle()
            UnlockHalfCircle()
                .foregroundColor(.gray)
                .opacity(0.8)
            
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

struct KeyDropPanel: View {
    
    @Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    
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

struct DoorIdPanel: View {
    let doorIndex: Int
    
    var formattedIndex: String {
        return (doorIndex < 10) ? "0\(doorIndex)" : "\(doorIndex)"
    }
    
    var body: some View {
        ZStack {
            DoorIdPlateRaw()
                .foregroundColor(.gray)
                .loweredShapeStyle()
            Text("\(formattedIndex)")
                .font(.system(size: 50))
                .foregroundColor(.offWhite)
        }
    }
}

struct SongInfoPanel: View {
    let doorIndex: Int
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("3:03")
                    .font(.system(size: 12))
                    .foregroundColor(.offWhite)
                Text("Makeup & Vanity Set")
                    .font(.system(size: 12))
                    .foregroundColor(.offWhite)
                Text("Homecoming")
                    .font(.system(size: 12))
                    .foregroundColor(.offWhite)
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



