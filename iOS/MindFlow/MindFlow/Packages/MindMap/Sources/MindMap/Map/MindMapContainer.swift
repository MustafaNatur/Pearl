import SwiftUI
import SharedModels

public struct MindMapContainer: View {
    let viewModel: MindMapViewModel

    public init(mindMap: MindMap, sync: @escaping (MindMap) -> ()) {
        self.viewModel = MindMapViewModel(mindMap: mindMap, sync: sync)
    }

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
    MindMapContainer(mindMap: .empty, sync: { _ in })
}
