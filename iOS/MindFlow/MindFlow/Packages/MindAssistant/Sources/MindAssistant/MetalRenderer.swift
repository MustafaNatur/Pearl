//
//  MetalRenderer.swift
//  MindAssistant
//
//  Created by Mustafa Natur on 22.11.2025.
//

import Metal
import MetalKit
import SwiftUI

/// The structure that defines the memory layout for data passed to the GPU.
/// This must match the `struct Uniforms` defined in the Metal shader exactly.
/// SIMD types (like SIMD3<Float>) ensure correct alignment and packing.
struct Uniforms {
    var iResolution: SIMD3<Float>   // Viewport resolution (width, height, depth)
    var iTime: Float                // Shader playback time (seconds)
    var iTimeDelta: Float           // Time since last frame (seconds)
    var iFrameRate: Float           // Estimated frames per second
    var iFrame: Int32               // Frame counter
    var iMouse: SIMD4<Float>        // Mouse/Touch coordinates
    
    // Control parameters - tweaked via UI
    var timeSpeed: Float            // Multiplier for time-based animation
    var iterations: Float           // Raymarching loop iterations (quality vs perf)
    var cameraDistance: Float       // Camera Z position
    var rotationSpeed: Float        // Auto-rotation speed
    var fbmIntensity: Float         // Noise intensity
    var colorIntensity: Float       // Color brightness multiplier
    var sphereRadius: Float         // Size of the main sphere
    
    // Interactive parameters - modified by gestures
    var yaw: Float                  // Horizontal rotation (radians)
    var pitch: Float                // Vertical rotation (radians)
    var explosion: Float            // Explosion intensity factor (0.0 to 1.0)
    var _pad: Float = 0.0           // Padding to align the next vector types if needed
    var explosionPos: SIMD2<Float>  // Normalized screen position of the explosion center
}

/// The renderer class responsible for managing the Metal device and drawing frames.
/// It acts as the delegate for the MTKView, meaning it gets called every frame to draw.
class MetalRenderer: NSObject, MTKViewDelegate {
    
    // MARK: - Metal Properties
    
    /// The interface to the GPU. Created once.
    var device: MTLDevice!
    
    /// The queue that organizes command buffers for the GPU to execute.
    var commandQueue: MTLCommandQueue!
    
    /// The compiled render state (shaders + configuration) used for drawing.
    /// It "bakes" the vertex and fragment functions together.
    var renderPipelineState: MTLRenderPipelineState!
    
    /// A buffer in GPU memory to hold our `Uniforms` data.
    /// This allows us to send dynamic data (time, rotation) to the shader every frame.
    var uniformBuffer: MTLBuffer!
    
    // MARK: - State Properties
    
    var startTime: CFTimeInterval!
    var lastFrameTime: CFTimeInterval!
    var frameCount: Int32 = 0
    
    // Control parameters with default values
    var timeSpeed: Float = 1.0
    var iterations: Float = 10.0
    var cameraDistance: Float = 7.0
    var rotationSpeed: Float = 1.0
    var fbmIntensity: Float = 0.2
    var colorIntensity: Float = 2.3
    var sphereRadius: Float = 4.0
    
    // Interactive state
    var yaw: Float = 0.0
    var pitch: Float = 0.0
    
    // Explosion animation state
    var explosion: Float = 0.0
    var explosionPos: SIMD2<Float> = SIMD2<Float>(0.5, 0.5)
    var explosionTime: Float = 0.0
    var isExploding: Bool = false
    let explosionDuration: Float = 0.6
    
    // MARK: - Initialization
    
    init?(metalView: MTKView) {
        super.init()
        
        // 1. Create the link to the GPU
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return nil
        }
        
        self.device = device
        metalView.device = device
        metalView.delegate = self
        
        // 2. Configure the view
        metalView.preferredFramesPerSecond = 60
        // 'bgra8Unorm' is a standard color format (Blue, Green, Red, Alpha, 8-bit unsigned normalized)
        metalView.colorPixelFormat = .bgra8Unorm
        // Clear to transparent so the background shows through if needed
        metalView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0) // Transparent
        
        // 3. Create the command queue
        guard let commandQueue = device.makeCommandQueue() else {
            print("Failed to create command queue")
            return nil
        }
        self.commandQueue = commandQueue
        
        // 4. Load the Shader Library
        // In Swift Package Manager, resources like .metal files are bundled in 'Bundle.module'.
        // We try to load from there first.
        let library: MTLLibrary?
        do {
            library = try device.makeDefaultLibrary(bundle: Bundle.module)
        } catch {
            print("Failed to load library from Bundle.module: \(error)")
            // Fallback for when running directly in an app project (not as a package dependency)
            library = device.makeDefaultLibrary()
        }
        
        guard let library = library else {
            print("Failed to load shader library")
            return nil
        }
        
        // 5. Get references to our shader functions by name
        guard let vertexFunction = library.makeFunction(name: "vertex_main"),
              let fragmentFunction = library.makeFunction(name: "fragment_main") else {
            print("Failed to load shader functions")
            return nil
        }
        
        // 6. Create the Render Pipeline State
        // This object represents the entire configuration of the GPU pipeline.
        // It is expensive to create, so we do it once here.
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        // Ensure the output format matches the view's format
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        
        // Enable blending to support transparency (Premultiplied Alpha)
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create render pipeline state: \(error)")
            return nil
        }
        
        // 7. Create a buffer to hold our uniform data
        // We allocate enough space for one instance of our 'Uniforms' struct.
        uniformBuffer = device.makeBuffer(length: MemoryLayout<Uniforms>.stride, options: [])
        
        // Initialize timing
        startTime = CACurrentMediaTime()
        lastFrameTime = startTime
    }
    
    // MARK: - Interaction Methods
    
    /// Called when the view changes size (rotation, window resize).
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // We handle resolution updates in the 'draw' loop via 'view.drawableSize',
        // so explicit handling here isn't strictly necessary for this shader.
    }
    
    /// Updates the rotation angles based on user gesture input.
    func updateRotation(deltaYaw: Float, deltaPitch: Float) {
        yaw += deltaYaw
        pitch += deltaPitch
    }
    
    /// Triggers the explosion animation at a specific normalized position (0-1).
    func triggerExplosion(at position: SIMD2<Float> = SIMD2<Float>(0.5, 0.5)) {
        isExploding = true
        explosionTime = 0.0
        
        // Metal uses a bottom-left origin for UVs in our shader logic (after conversion),
        // but UI coordinates are top-left. We flip Y here to align them.
        explosionPos = SIMD2<Float>(position.x, 1.0 - position.y)
    }
    
    // MARK: - Drawing Loop
    
    /// Called up to 60 times per second to render a frame.
    func draw(in view: MTKView) {
        // 1. Get the 'drawable' (the texture we draw into) and the pipeline state.
        guard let drawable = view.currentDrawable,
              let renderPipelineState = renderPipelineState,
              let uniformBuffer = uniformBuffer else {
            return
        }
        
        // 2. Calculate Timing
        let currentTime = CACurrentMediaTime()
        let elapsedTime = Float(currentTime - startTime)
        let deltaTime = Float(currentTime - lastFrameTime)
        lastFrameTime = currentTime
        
        frameCount += 1
        
        // 3. Update Animation Logic (Explosion)
        if isExploding {
            explosionTime += deltaTime
            if explosionTime >= explosionDuration {
                // Animation finished
                isExploding = false
                explosion = 0.0
            } else {
                // Calculate smooth curve (Sine Wave 0 -> 1 -> 0) based on progress
                let progress = explosionTime / explosionDuration
                explosion = sin(progress * Float.pi)
            }
        }
        
        // 4. Prepare Uniforms
        // We package all current state into the struct to send to the shader.
        let uniforms = Uniforms(
            iResolution: SIMD3<Float>(Float(view.drawableSize.width), Float(view.drawableSize.height), 0),
            iTime: elapsedTime,
            iTimeDelta: deltaTime,
            iFrameRate: deltaTime > 0 ? 1.0 / deltaTime : 60.0,
            iFrame: frameCount,
            iMouse: SIMD4<Float>(0, 0, 0, 0), // Mouse input can be extended here
            timeSpeed: timeSpeed,
            iterations: iterations,
            cameraDistance: cameraDistance,
            rotationSpeed: rotationSpeed,
            fbmIntensity: fbmIntensity,
            colorIntensity: colorIntensity,
            sphereRadius: sphereRadius,
            yaw: yaw,
            pitch: pitch,
            explosion: explosion,
            _pad: 0.0,
            explosionPos: explosionPos
        )
        
        // 5. Copy Uniforms to GPU Buffer
        // We get a raw pointer to the buffer's memory and overwrite it with our struct.
        let uniformPointer = uniformBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        uniformPointer.pointee = uniforms
        
        // 6. Create Command Buffer
        // This object stores the list of commands for the GPU to execute this frame.
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // 7. Encode Drawing Commands
        // The RenderCommandEncoder translates our high-level intent into GPU commands.
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(renderPipelineState)
        
        // Bind our uniform buffer to index 0 in the shader's buffer argument table
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        
        // Draw a full-screen triangle (3 vertices).
        // The vertex shader positions these to cover the screen.
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder.endEncoding()
        
        // 8. Present and Commit
        // Tell the system to show this drawable when done
        commandBuffer.present(drawable)
        // Send the buffer to the GPU queue for execution
        commandBuffer.commit()
    }
}
