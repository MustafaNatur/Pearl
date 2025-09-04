import SwiftUI
import SharedModels

public struct MindMapContainer: View {
    @Environment(\.scenePhase) private var scenePhase
    let viewModel: MindMapViewModel

    public init(mindMapId: String) {
        self.viewModel = MindMapViewModel(mindMapId: mindMapId)
    }

    public var body: some View {
        MindMapView(
            mindMap: viewModel.mindMap ?? .empty, // handle nilled mindMap
            isInConnectionMode: viewModel.connectionMode,
            nodeIsSelected: viewModel.isNodeSelected,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            addItemAction: viewModel.createNode,
            toggleConnectionModeAction: viewModel.toggleConnectionMode,
            onTaskTapCompleted: viewModel.onTaskTapCompleted
        )
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.saveChanges)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.saveChanges()
            }
        }
    }
}

#Preview {
    MindMapContainer(mindMapId: "1")
}
