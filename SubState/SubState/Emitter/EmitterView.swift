//
//  EmitterView.swift
//  SubState
//
//  Created by Josh Kneedler on 9/11/20.
//

import SwiftUI
/*
class AnyShape {
    let value: Any
    
    init<T: Shape>(_ shape: T) {
        self.value = shape
    }
}
 */

/*
 /*
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
*/
 */


/// A particle emitter that creates a series of `ParticleView` instances for individual particles.
struct EmitterView: View {
    /// A pair of values representing the before and after state for a given piece of particle data
    private struct ParticleState<T> {
        var start: T
        var end: T

        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }

    /// One particle in the emitter
    private struct ParticleView: View {
        /// Flip to true to move this particle between its start and end state
        @State var isActive: Bool = false

        //let image: Image
        let particleView: AnyView
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let scale: ParticleState<CGFloat>
        let rotation: ParticleState<Angle>
        let color: Color
        let animation: Animation
        let blendMode: BlendMode

        var body: some View {
            //image
            particleView
                .colorMultiply(color)
                .blendMode(blendMode)
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .rotationEffect(isActive ? rotation.end : rotation.start)
                .position(isActive ? position.end : position.start)
                .onAppear {
                    withAnimation(self.animation) {
                        self.isActive = true
                    }
                }
        }
    }

    //var images: [String]
    var particleViews: [AnyView]
    var particleCount = 100

    var creationPoint = UnitPoint.center
    var creationRange = CGSize.zero

    var colors = [Color.white]

    var alpha: Double = 1
    var alphaRange: Double = 0
    var alphaSpeed: Double = 0

    var angle = Angle.zero
    var angleRange = Angle.zero

    var rotation = Angle.zero
    var rotationRange = Angle.zero
    var rotationSpeed = Angle.zero

    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0

    var speed = 50.0
    var speedRange = 0.0

    var animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    var animationDelayThreshold = 0.0

    var blendMode = BlendMode.normal

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<self.particleCount, id: \.self) { i in
                    ParticleView(
                        //image: Image(self.images.randomElement()!),
                        particleView: self.particleViews.randomElement()!,
                        position: self.position(in: geo),
                        opacity: self.makeOpacity(),
                        scale: self.makeScale(),
                        rotation: self.makeRotation(),
                        color: self.colors.randomElement() ?? .white,
                        animation: self.animation.delay(Double.random(in: 0...self.animationDelayThreshold)),
                        blendMode: self.blendMode
                    )
                }
            }
        }
    }

    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        let halfCreationRangeWidth = creationRange.width / 2
        let halfCreationRangeHeight = creationRange.height / 2

        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
        let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeHeight)

        let startX = (proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = (proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)

        let halfSpeedRange = speedRange / 2
        let actualSpeed  = Double.random(in: speed - halfSpeedRange...speed + halfSpeedRange)

        let halfAngleRange = angleRange.radians / 2
        let totalRange = Double.random(in: angle.radians - halfAngleRange...angle.radians + halfAngleRange)

        let finalX = cos(totalRange - .pi / 2) * actualSpeed
        let finalY = sin(totalRange - .pi / 2) * actualSpeed
        let end = CGPoint(x: Double(startX) + finalX, y: Double(startY) + finalY)

        return ParticleState(start, end)
    }

    private func makeOpacity() -> ParticleState<Double> {
        let halfAlphaRange = alphaRange / 2
        let randomAlpha = Double.random(in: -halfAlphaRange...halfAlphaRange)
        return ParticleState(alpha + randomAlpha, alpha + alphaSpeed + randomAlpha)
    }

    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }

    private func makeRotation() -> ParticleState<Angle> {
        let halfRotationRange = (rotationRange / 2).degrees
        let randomRotation = Double.random(in: -halfRotationRange...halfRotationRange)
        let randomRotationAngle = Angle(degrees: randomRotation)
        return ParticleState(rotation + randomRotationAngle, rotation + rotationSpeed + randomRotationAngle)
    }
}
