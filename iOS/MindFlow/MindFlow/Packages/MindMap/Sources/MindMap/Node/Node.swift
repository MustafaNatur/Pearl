import SwiftUI

struct Node: Identifiable, Equatable {
    let id: UUID
    var title: String
    var position: CGPoint
    var color: Color
}
