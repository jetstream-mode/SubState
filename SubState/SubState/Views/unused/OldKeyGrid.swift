//
//  OldKeyGrid.swift
//  SubState
//
//  Created by Josh Kneedler on 12/1/20.
//

import Foundation

/*
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
*/
