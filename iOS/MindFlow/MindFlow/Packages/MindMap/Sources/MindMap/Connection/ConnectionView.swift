import SwiftUI

struct ConnectionView: View {
    var from: CGPoint
    var to: CGPoint
    
    var body: some View {
        Path { path in
            let start = from
            let end = to
            let control1 = CGPoint(x: start.x, y: (start.y + end.y) / 2)
            let control2 = CGPoint(x: end.x, y: (start.y + end.y) / 2)
            
            path.move(to: start)
            path.addCurve(to: end, control1: control1, control2: control2)
        }
        .stroke(
            Color.black,
            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [])
        )
        .overlay(
            ArrowShape()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 10, height: 10)
                .position(calculateArrowPosition(from: from, to: to))
        )
        .animation(.easeInOut(duration: 0.1), value: from)
        .animation(.easeInOut(duration: 0.1), value: to)
    }
    
    // Calculate the position for the arrow at the end of the curve
    func calculateArrowPosition(from: CGPoint, to: CGPoint) -> CGPoint {
        // Calculate the angle of the line
        let dx = to.x - from.x
        let dy = to.y - from.y
        let angle = atan2(dy, dx)
        
        // Position the arrow slightly before the end point
        let arrowLength: CGFloat = 10
        let arrowX = to.x - arrowLength * cos(angle)
        let arrowY = to.y - arrowLength * sin(angle)
        
        return CGPoint(x: arrowX, y: arrowY)
    }
}
