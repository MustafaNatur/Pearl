import SwiftUI

public struct MindMapContainer: View {
    @State var viewModel = MindMapViewModel()

    public init() {}

    public var body: some View {
        MindMapView(
            mindMap: viewModel.mindMap,
            isInConnectionMode: viewModel.connectionMode,
            nodeIsSelected: viewModel.isNodeSelected,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            addItemAction: viewModel.createNode,
            toggleConnectionModeAction: viewModel.toggleConnectionMode,
            onTaskTapCompleted: viewModel.onTaskTapCompleted
        )
    }
}

#Preview {
    MindMapContainer()
}
