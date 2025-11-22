//
//  DemoView.swift
//  MindAssistant
//
//  Created by Mustafa Natur on 22.11.2025.
//

import SwiftUI

public struct DemoView: View {
    @State private var timeSpeed: Float = 1.0
    @State private var iterations: Float = 10.0
    @State private var cameraDistance: Float = 7.0
    @State private var rotationSpeed: Float = 1.0
    @State private var fbmIntensity: Float = 0.2
    @State private var colorIntensity: Float = 2.3
    @State private var sphereRadius: Float = 4.0
    
    @State private var showControls = true

    public init(

    ) {
       
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            MetalView(
                timeSpeed: timeSpeed,
                iterations: iterations,
                cameraDistance: cameraDistance,
                rotationSpeed: rotationSpeed,
                fbmIntensity: fbmIntensity,
                colorIntensity: colorIntensity,
                sphereRadius: sphereRadius
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        showControls.toggle()
                    }
                }) {
                    Image(systemName: showControls ? "chevron.down" : "slider.horizontal.3")
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(Circle())
                }
                .padding(.bottom)
                
                if showControls {
                    ScrollView {
                        VStack(spacing: 20) {
                            ControlRow(title: "Time Speed", value: $timeSpeed, range: 0...5)
                            ControlRow(title: "Iterations", value: $iterations, range: 1...50, step: 1)
                            ControlRow(title: "Camera Dist", value: $cameraDistance, range: 1...20)
                            ControlRow(title: "Rot Speed", value: $rotationSpeed, range: 0...5)
                            ControlRow(title: "FBM Intensity", value: $fbmIntensity, range: 0...1)
                            ControlRow(title: "Color Intensity", value: $colorIntensity, range: 0...5)
                            ControlRow(title: "Sphere Radius", value: $sphereRadius, range: 0.1...10)
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300)
                    .background(.regularMaterial)
                    #if os(iOS)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    #else
                    .cornerRadius(20)
                    #endif
                }
            }
        }
    }
}

struct ControlRow: View {
    let title: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    var step: Float = 0.01
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.caption)
                    .bold()
                Spacer()
                Text(String(format: "%.2f", value))
                    .font(.caption)
                    .monospacedDigit()
            }
            
            Slider(value: $value, in: range, step: step)
        }
    }
}

#Preview {
    DemoView()
}
