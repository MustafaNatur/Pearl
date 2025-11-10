import SwiftUI

// MARK: - Dynamic Gradient Demo
struct GradientDemo: View {
    
    @State private var selectedColor: Color = .blue
    
    let sampleColors: [Color] = [
        .red, .blue, .green, .orange, .purple, .pink, .yellow, .cyan
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Color Picker
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Accent Color")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(sampleColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(.white, lineWidth: selectedColor == color ? 4 : 0)
                                )
                                .shadow(radius: 3)
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    
                    ColorPicker("Custom Color", selection: $selectedColor)
                }
                
                // MARK: - Gradient Preview
                VStack(alignment: .leading, spacing: 16) {
                    Text("Random Mesh Gradient")
                        .font(.headline)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedColor.dynamicGradient)
                        .frame(height: 250)
                        .overlay(
                            Text("Random Each Time")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .shadow(radius: 4)
                        )
                        .animation(.easeInOut(duration: 0.5), value: selectedColor)
                }
                
                // MARK: - Seeded Gradient Preview
                VStack(alignment: .leading, spacing: 16) {
                    Text("Seeded Mesh Gradient")
                        .font(.headline)
                    
                    Text("Same seed = same gradient")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor.dynamicGradient(seed: "12345"))
                            .frame(height: 150)
                            .overlay(
                                Text("Seed: 12345")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 2)
                            )
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor.dynamicGradient(seed: "67890"))
                            .frame(height: 150)
                            .overlay(
                                Text("Seed: 67890")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 2)
                            )
                    }
                    
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor.dynamicGradient(seed: "12345"))
                            .frame(height: 150)
                            .overlay(
                                Text("Seed: 12345")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 2)
                            )
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor.dynamicGradient(seed: "67890"))
                            .frame(height: 150)
                            .overlay(
                                Text("Seed: 67890")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 2)
                            )
                    }
                }
                
                // MARK: - Usage Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Usage Examples")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        // Button
                        Button("Gradient Button") {}
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(selectedColor.dynamicGradient)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .cornerRadius(12)
                        
                        // Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Card")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("With mesh gradient background")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(selectedColor.dynamicGradient)
                        .cornerRadius(16)
                    }
                }
                
                // MARK: - Code
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to Use")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Random Gradient:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            CodeBlock(code: "Color.blue.dynamicGradient")
                            CodeBlock(code: "MeshGradient.dynamicGradient(accentColor: .red)")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Seeded Gradient (deterministic):")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            CodeBlock(code: "Color.blue.dynamicGradient(seed: plan.id)")
                            CodeBlock(code: "MeshGradient.dynamicGradient(accentColor: .red, seed: uuid)")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Mesh Gradients")
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Supporting Views
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
