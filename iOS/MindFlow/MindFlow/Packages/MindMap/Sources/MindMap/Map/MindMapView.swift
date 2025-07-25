import SwiftUI

struct MindMapView: View {
    @State var viewModel = MindMapViewModel()

    @State private var showingAddNode = false
    @State private var newNodeTitle = ""
    @State private var newNodeColor: Color = Color.orange

    // Zoom and Pan states
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // Zoom and Pan
            CanvasView(viewModel: viewModel)
                .scaleEffect(scale)
                .offset(offset)

        }
        .gesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / self.lastScale
                        self.lastScale = value
                        self.scale *= delta
                    }
                    .onEnded { _ in
                        self.lastScale = 1.0
                    },
                DragGesture()
                    .onChanged { value in
                        self.offset = CGSize(width: self.lastOffset.width + value.translation.width, height: self.lastOffset.height + value.translation.height)
                    }
                    .onEnded { _ in
                        self.lastOffset = self.offset
                    }
            )
        )
        .navigationBarTitle("Mind Mapper", displayMode: .inline)
        .navigationBarItems(trailing:
                                HStack {
            Button(action: {
                self.showingAddNode = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }

            Button(action: {
                viewModel.toggleConnectionMode()
            }) {
                Image(systemName: viewModel.connectionMode ? "link.circle.fill" : "link.circle")
                    .font(.title)
                    .foregroundColor(viewModel.connectionMode ? .green : .gray)
            }
        }
        )
        .sheet(isPresented: $showingAddNode) {
            AddNodeView(viewModel: viewModel, isPresented: $showingAddNode, newNodeTitle: $newNodeTitle, newNodeColor: $newNodeColor)
        }
    }
}

#Preview {
    NavigationStack {
        MindMapView()
    }
}
