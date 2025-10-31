import SwiftUI
import SharedModels
import TaskScreen

public struct MindMapContainer: View {
    @Environment(\.scenePhase) private var scenePhase

    @State var viewModel: MindMapViewModel

    public init(mindMapId: String) {
        self.viewModel = MindMapViewModel(mindMapId: mindMapId)
    }

    public var body: some View {
        MindMapView(
            lastScale: $viewModel.lastZoomScale,
            lastOffset: $viewModel.lastOffset,
            mindMap: viewModel.mindMap ?? .empty, // TODO: handle nilled mindMap
            currentMode: viewModel.currentMode,
            nodeIsSelected: viewModel.isNodeSelected,
            onNodeTapCompleted: viewModel.onNodeTapCompleted,
            updateNodePosition: viewModel.updateNodePosition,
            selectNodeForConnection: viewModel.selectNodeForConnection,
            toggleModeAction: viewModel.toggleMode,
            deleteConnection: viewModel.deleteConnection,
            navigateToNodeScreen: viewModel.navigateToNodeScreen,
            navigateToNodeDeleteAlert: viewModel.navigateToNodeDeleteAlert,
            navigateToCreationNodeSheet: viewModel.navigateToCreationNodeSheet
        )
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.saveChanges)
        .navigationDestination(item: $viewModel.nodeToNavigate) { node in
            TaskScreenView(
                task: node.task,
                onEdit: { updatedTask in
                    viewModel.onUpdateTask(updatedTask, nodeId: node.id)
                    viewModel.nodeToNavigate = nil
                },
                onDelete: {
                    viewModel.deleteNode(node.id)
                    viewModel.nodeToNavigate = nil
                }
            )
        }
        .sheet(isPresented: $viewModel.creationSheetIsPresented) {
            NodeFormView(onTapAction: viewModel.createNode)
        }
        .deleteConfirmationAlert(
            item: $viewModel.nodeToDelete,
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            onConfirm: viewModel.onConfirmDeleteNode
        )
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
