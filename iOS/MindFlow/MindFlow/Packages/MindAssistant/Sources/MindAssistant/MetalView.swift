//
//  MetalView.swift
//  MindAssistant
//
//  Created by Mustafa Natur on 22.11.2025.
//

import SwiftUI
import MetalKit

/// A SwiftUI wrapper for a Metal-backed view (MTKView).
/// It uses `UIViewRepresentable` (on iOS) or `NSViewRepresentable` (on macOS) to embed
/// the UIKit/AppKit view into the SwiftUI hierarchy.
public struct MetalView: UIViewRepresentable {
    
    // MARK: - Configuration Properties
    // These properties are set by the SwiftUI parent view.
    // When they change, `updateUIView` is called, allowing us to update the renderer.
    
    public var timeSpeed: Float
    public var iterations: Float
    public var cameraDistance: Float
    public var rotationSpeed: Float
    public var fbmIntensity: Float
    public var colorIntensity: Float
    public var sphereRadius: Float
    
    /// Public initializer to allow creating this view from other modules/packages.
    public init(
        timeSpeed: Float = 1.0,
        iterations: Float = 10.0,
        cameraDistance: Float = 7.0,
        rotationSpeed: Float = 1.0,
        fbmIntensity: Float = 0.2,
        colorIntensity: Float = 2.3,
        sphereRadius: Float = 4.0
    ) {
        self.timeSpeed = timeSpeed
        self.iterations = iterations
        self.cameraDistance = cameraDistance
        self.rotationSpeed = rotationSpeed
        self.fbmIntensity = fbmIntensity
        self.colorIntensity = colorIntensity
        self.sphereRadius = sphereRadius
    }
    
    // MARK: - View Creation
    
    /// Creates the underlying UIKit view (MTKView).
    public func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        
        // Optimizations for SwiftUI usage
        metalView.enableSetNeedsDisplay = false // We want a continuous game loop, not event-driven drawing
        metalView.isPaused = false              // Start rendering immediately
        metalView.preferredFramesPerSecond = 60
        
        // Transparency setup
        metalView.backgroundColor = .clear
        metalView.isOpaque = false // Allows the system background to show through transparent pixels
        
        // Initialize the renderer (delegate)
        // We store the renderer in the Coordinator so it persists across SwiftUI updates.
        let renderer = MetalRenderer(metalView: metalView)
        context.coordinator.renderer = renderer
        
        // Apply initial configuration to the renderer
        if let renderer = renderer {
            renderer.timeSpeed = timeSpeed
            renderer.iterations = iterations
            renderer.cameraDistance = cameraDistance
            renderer.rotationSpeed = rotationSpeed
            renderer.fbmIntensity = fbmIntensity
            renderer.colorIntensity = colorIntensity
            renderer.sphereRadius = sphereRadius
        }
        
        // MARK: - Gesture Setup
        // We attach gestures directly to the MTKView.
        // The Coordinator acts as the target/delegate for these gestures.
        
        // 1. Pan Gesture (Rotation)
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        metalView.addGestureRecognizer(panGesture)
        
        // 2. Double Tap Gesture (Light Explosion)
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        metalView.addGestureRecognizer(doubleTapGesture)
        
        return metalView
    }
    
    // MARK: - View Updates
    
    /// Called whenever the SwiftUI state changes (e.g., user moves a slider).
    /// We push the new values to the renderer immediately.
    public func updateUIView(_ uiView: MTKView, context: Context) {
        guard let renderer = context.coordinator.renderer else { return }
        
        renderer.timeSpeed = timeSpeed
        renderer.iterations = iterations
        renderer.cameraDistance = cameraDistance
        renderer.rotationSpeed = rotationSpeed
        renderer.fbmIntensity = fbmIntensity
        renderer.colorIntensity = colorIntensity
        renderer.sphereRadius = sphereRadius
    }
    
    // MARK: - Coordinator
    
    /// Creates the Coordinator which handles communication between UIKit and SwiftUI.
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    /// The Coordinator class. It stores the Renderer and handles Gesture events.
    /// It must inherit from NSObject to be a selector target for UIGestureRecognizers.
    public class Coordinator: NSObject {
        var renderer: MetalRenderer?
        
        /// Handles drag gestures to rotate the view.
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let renderer = renderer else { return }
            let translation = gesture.translation(in: gesture.view)
            let sensitivity: Float = 0.01 // Radians per pixel moved
            
            renderer.updateRotation(
                deltaYaw: Float(translation.x) * sensitivity,
                // Negative Y because dragging down usually means "look down" (negative pitch around X axis)
                deltaPitch: -Float(translation.y) * sensitivity
            )
            
            // Reset translation to 0 so we get delta movement next frame
            gesture.setTranslation(.zero, in: gesture.view)
        }
        
        /// Handles double-tap gestures to trigger effects.
        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let view = gesture.view else { return }
            
            // Calculate normalized tap position (0.0 to 1.0) relative to the view
            let location = gesture.location(in: view)
            let normalizedX = Float(location.x / view.bounds.width)
            let normalizedY = Float(location.y / view.bounds.height)
            
            renderer?.triggerExplosion(at: SIMD2<Float>(normalizedX, normalizedY))
        }
    }
}
