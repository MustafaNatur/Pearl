import SwiftUI

struct CanvasView: View {
    var viewModel: MindMapViewModel
    
    var body: some View {
        ZStack {
            ForEach(viewModel.mindMap.connections) { connection in
                if let fromNode = viewModel.mindMap.nodes.first(where: { $0.id == connection.from }),
                   let toNode = viewModel.mindMap.nodes.first(where: { $0.id == connection.to }) {
                    ConnectionView(from: fromNode.position, to: toNode.position)
                }
            }

            ForEach(viewModel.mindMap.nodes) { node in
                NodeView(viewModel: viewModel, node: node)
            }
        }
    }
}
