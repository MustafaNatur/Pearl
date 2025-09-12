import SwiftUI
import SharedModels

public struct MindMapContainer: View {
    @Environment(\.scenePhase) private var scenePhase

    @State var viewModel: MindMapViewModel

    public init(mindMapId: String) {
        self.viewModel = MindMapViewModel(mindMapId: mindMapId)
    }

    public var body: some View {
        MindMapView(
            mindMap: viewModel.mindMap ?? .empty, // TODO: handle nilled mindMap
            currentMode: viewModel.currentMode,
            nodeIsSelected: viewModel.isNodeSelected,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            addItemAction: viewModel.createNode,
            toggleModeAction: viewModel.toggleMode,
            onTaskTapCompleted: viewModel.onTaskTapCompleted,
            onTaskDeleteTapped: viewModel.deleteTask,
            onConnectionDeleteTapped: viewModel.deleteConnection,
            onNodeDeleteTapped: viewModel.deleteNode,
            onUpdateTask: viewModel.onUpdateTask
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
