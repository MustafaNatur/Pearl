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
            currentMode: viewModel.currentMode,
            nodeIsSelected: viewModel.isNodeSelected,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            addItemAction: viewModel.createNode,
            toggleModeAction: viewModel.toggleMode(to:),
            onTaskTapCompleted: viewModel.onTaskTapCompleted,
            onConnectionDeleteTapped: viewModel.deleteConnection,
            onNodeDeleteTapped: viewModel.deleteNode
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
