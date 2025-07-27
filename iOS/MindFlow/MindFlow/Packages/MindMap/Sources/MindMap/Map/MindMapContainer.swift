import SwiftUI

struct MindMapContainer: View {
    @State var viewModel = MindMapViewModel()

    var body: some View {
        MindMapView(
            mindMap: viewModel.mindMap,
            isInConnectionMode: viewModel.connectionMode,
            nodeIsSelected: viewModel.isNodeSelected(_:),
            updateNodePosition: viewModel.updateNodePosition(_:newPosition:),
            selectNodeForConnection: viewModel.selectNodeForConnection(_:),
            addItemAction: viewModel.showAddNodeMenu,
            toggleConnectionModeAction: viewModel.toggleConnectionMode
        )
        .sheet(isPresented: $viewModel.showingAddNodeMenu) {
            AddNodeView(createNodeAction: viewModel.createNode(title:color:))
        }
    }
}

#Preview {
    MindMapContainer()
}
