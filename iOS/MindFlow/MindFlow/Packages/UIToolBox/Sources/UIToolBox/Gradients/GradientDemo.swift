import SwiftUI

// MARK: - Dynamic Gradient Demo
struct GradientDemo: View {
    
    @State private var selectedColor: Color = .blue
    
    let sampleColors: [Color] = [
        .red, .blue, .green, .orange, .purple, .pink, .yellow, .cyan,
        Color(red: 0.2, green: 0.8, blue: 0.4), // Custom green
        Color(red: 0.9, green: 0.3, blue: 0.7), // Custom pink
        Color(red: 0.1, green: 0.4, blue: 0.9), // Custom blue
        Color(red: 0.8, green: 0.6, blue: 0.2)  // Custom orange
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Color Picker
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Your Accent Color")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(Array(sampleColors.enumerated()), id: \.offset) { index, color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? .white : .clear, lineWidth: 3)
                                        .shadow(color: .black.opacity(0.3), radius: 2)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 2)
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    
                    ColorPicker("Custom Color", selection: $selectedColor)
                        .padding(.top, 8)
                }
                
                // MARK: - Generated Gradient Preview
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Soft Dynamic Gradient")
                        .font(.headline)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedColor.dynamicGradient)
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Text("Beautiful Soft Transitions")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 2)
                                
                                Text("4-color gradient with smooth blending")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.5), radius: 1)
                            }
                        )
                        .animation(.easeInOut(duration: 0.5), value: selectedColor)
                }
                
                // MARK: - Comparison
                VStack(alignment: .leading, spacing: 16) {
                    Text("Before vs After")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedColor)
                                .frame(height: 100)
                            
                            Text("Single Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedColor.dynamicGradient)
                                .frame(height: 100)
                            
                            Text("Soft Dynamic Gradient")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // MARK: - Usage Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Usage Examples")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        
                        // Button Example
                        Button("Gradient Button") {
                            // Action
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedColor.dynamicGradient)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        // Card Example
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Task Card")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text("With soft gradient background")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.white.opacity(0.8))
                                Text("Due tomorrow")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .padding()
                        .background(LinearGradient.generate(accentColor: selectedColor))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        
                        // Text Example
                        Text("Gradient Text")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(selectedColor.gradient)
                        
                        // Icon Examples
                        HStack(spacing: 20) {
                            ForEach(["heart.fill", "star.fill", "leaf.fill", "flame.fill"], id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.title)
                                    .foregroundStyle(selectedColor.dynamicGradient)
                            }
                        }
                    }
                }
                
                // MARK: - Code Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to Use")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        CodeBlock(code: ".background(Color.blue.dynamicGradient)")
                        CodeBlock(code: ".foregroundStyle(myColor.gradient)")
                        CodeBlock(code: "LinearGradient.generate(accentColor: .red)")
                        CodeBlock(code: "LinearGradient.dynamicGradient(accentColor: selectedColor)")
                    }
                }
                
                // MARK: - Features
                VStack(alignment: .leading, spacing: 16) {
                    Text("What Makes It Soft")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(
                            icon: "paintbrush.fill",
                            title: "4 Colors",
                            description: "Uses 4 colors instead of 3 for smoother transitions"
                        )
                        
                        FeatureRow(
                            icon: "slider.horizontal.3",
                            title: "Subtle Variations",
                            description: "Only ±30° hue shift instead of dramatic changes"
                        )
                        
                        FeatureRow(
                            icon: "circle.hexagongrid.fill",
                            title: "Lower Saturation",
                            description: "Reduces saturation for softer, more pleasing colors"
                        )
                        
                        FeatureRow(
                            icon: "wand.and.stars",
                            title: "Analogous Colors",
                            description: "Uses color theory for harmonious combinations"
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dynamic Gradients")
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Supporting Views
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        GradientDemo()
    }
}
