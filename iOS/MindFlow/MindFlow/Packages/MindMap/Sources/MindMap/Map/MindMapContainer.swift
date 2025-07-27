import SwiftUI

struct MindMapContainer: View {
    @State var viewModel = MindMapViewModel()

    var body: some View {
        MindMapView(
            mindMap: viewModel.mindMap,
            isInConnectionMode: viewModel.connectionMode,
            nodeIsSelected: viewModel.isNodeSelected,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            addItemAction: viewModel.addNode,
            toggleConnectionModeAction: viewModel.toggleConnectionMode
        )
    }
}

#Preview {
    MindMapContainer()
}
