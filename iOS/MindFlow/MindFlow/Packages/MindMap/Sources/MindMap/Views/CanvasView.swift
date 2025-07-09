import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: MindMapViewModel
    
    var body: some View {
        ZStack {
            ForEach(viewModel.connections) { connection in
                if let fromNode = viewModel.nodes.first(where: { $0.id == connection.from }),
                   let toNode = viewModel.nodes.first(where: { $0.id == connection.to }) {
                    ConnectionView(from: fromNode.position, to: toNode.position)
                }
            }

            ForEach(viewModel.nodes) { node in
                NodeView(viewModel: viewModel, node: node)
            }
        }
    }
}
