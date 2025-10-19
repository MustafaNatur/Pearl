import SwiftUI
import UIToolBox

// Arrow configuration
private enum ArrowConfig {
    static let length: CGFloat = 35
    static let width: CGFloat = 14
}

struct ConnectionView: View {
    let from: CGPoint
    let to: CGPoint
    let showDeleteButton: Bool
    let onDeleteTapped: (() -> Void)?

    var body: some View {
        ZStack {
            // Connection line
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
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            
            // Filled arrow
            arrowPath
                .fill(Color.black)
        }
        .overlay(
            DeleteButtonOverlay
                .opacity(showDeleteButton ? 1 : 0)
                .animation(.default, value: showDeleteButton)
        )
    }
    
    // Create a filled arrow path
    private var arrowPath: Path {
        Path { path in
            let midPoint = calculateMidPoint()
            let angle = calculateCurveTangentAngle()
            
            // Arrow tip points forward (in direction of connection)
            let arrowTip = CGPoint(
                x: midPoint.x + ArrowConfig.length / 2 * cos(angle),
                y: midPoint.y + ArrowConfig.length / 2 * sin(angle)
            )
            
            // Arrow base is behind the midpoint
            let arrowBase = CGPoint(
                x: midPoint.x - ArrowConfig.length / 2 * cos(angle),
                y: midPoint.y - ArrowConfig.length / 2 * sin(angle)
            )
            
            // Left wing of arrow (perpendicular to direction)
            let leftWing = CGPoint(
                x: arrowBase.x - ArrowConfig.width / 2 * sin(angle),
                y: arrowBase.y + ArrowConfig.width / 2 * cos(angle)
            )
            
            // Right wing of arrow (perpendicular to direction)
            let rightWing = CGPoint(
                x: arrowBase.x + ArrowConfig.width / 2 * sin(angle),
                y: arrowBase.y - ArrowConfig.width / 2 * cos(angle)
            )
            
            // Draw filled triangle with rounded corners
            let cornerRadius: CGFloat = 4
            
            // Calculate points slightly inset from corners for rounded effect
            let tipToLeftDist = sqrt(pow(leftWing.x - arrowTip.x, 2) + pow(leftWing.y - arrowTip.y, 2))
            let tipToRightDist = sqrt(pow(rightWing.x - arrowTip.x, 2) + pow(rightWing.y - arrowTip.y, 2))
            let leftToRightDist = sqrt(pow(rightWing.x - leftWing.x, 2) + pow(rightWing.y - leftWing.y, 2))
            
            // Start point near tip (on left edge)
            let startPoint = CGPoint(
                x: arrowTip.x + (leftWing.x - arrowTip.x) * cornerRadius / tipToLeftDist,
                y: arrowTip.y + (leftWing.y - arrowTip.y) * cornerRadius / tipToLeftDist
            )
            
            // End point near tip (on right edge)
            let endPoint = CGPoint(
                x: arrowTip.x + (rightWing.x - arrowTip.x) * cornerRadius / tipToRightDist,
                y: arrowTip.y + (rightWing.y - arrowTip.y) * cornerRadius / tipToRightDist
            )
            
            // Points near left wing
            let leftStart = CGPoint(
                x: leftWing.x + (arrowTip.x - leftWing.x) * cornerRadius / tipToLeftDist,
                y: leftWing.y + (arrowTip.y - leftWing.y) * cornerRadius / tipToLeftDist
            )
            let leftEnd = CGPoint(
                x: leftWing.x + (rightWing.x - leftWing.x) * cornerRadius / leftToRightDist,
                y: leftWing.y + (rightWing.y - leftWing.y) * cornerRadius / leftToRightDist
            )
            
            // Points near right wing
            let rightStart = CGPoint(
                x: rightWing.x + (leftWing.x - rightWing.x) * cornerRadius / leftToRightDist,
                y: rightWing.y + (leftWing.y - rightWing.y) * cornerRadius / leftToRightDist
            )
            let rightEnd = CGPoint(
                x: rightWing.x + (arrowTip.x - rightWing.x) * cornerRadius / tipToRightDist,
                y: rightWing.y + (arrowTip.y - rightWing.y) * cornerRadius / tipToRightDist
            )
            
            path.move(to: startPoint)
            path.addLine(to: leftStart)
            path.addQuadCurve(to: leftEnd, control: leftWing)
            path.addLine(to: rightStart)
            path.addQuadCurve(to: rightEnd, control: rightWing)
            path.addLine(to: endPoint)
            path.addQuadCurve(to: startPoint, control: arrowTip)
            path.closeSubpath()
        }
    }
    
    @ViewBuilder
    private var DeleteButtonOverlay: some View {
        if showDeleteButton, let onDeleteTapped = onDeleteTapped {
            DeleteButton(action: onDeleteTapped)
                .position(calculateMidPoint())
                .opacity(showDeleteButton ? 1 : 0)
        }
    }
    
    // Calculate the tangent angle of the Bézier curve at t=0.5 (midpoint)
    private func calculateCurveTangentAngle() -> CGFloat {
        let start = from
        let end = to
        let control1 = CGPoint(x: start.x, y: (start.y + end.y) / 2)
        let control2 = CGPoint(x: end.x, y: (start.y + end.y) / 2)
        
        // For a cubic Bézier curve at t=0.5, the derivative (tangent) is:
        // B'(t) = 3(1-t)²(P1-P0) + 6(1-t)t(P2-P1) + 3t²(P3-P2)
        let t: CGFloat = 0.5
        let oneMinusT = 1 - t
        
        let dx = 3 * oneMinusT * oneMinusT * (control1.x - start.x) +
                 6 * oneMinusT * t * (control2.x - control1.x) +
                 3 * t * t * (end.x - control2.x)
        
        let dy = 3 * oneMinusT * oneMinusT * (control1.y - start.y) +
                 6 * oneMinusT * t * (control2.y - control1.y) +
                 3 * t * t * (end.y - control2.y)
        
        return atan2(dy, dx)
    }
    
    // Calculate the midpoint of the connection curve using Bézier formula at t=0.5
    func calculateMidPoint() -> CGPoint {
        let start = from
        let end = to
        let control1 = CGPoint(x: start.x, y: (start.y + end.y) / 2)
        let control2 = CGPoint(x: end.x, y: (start.y + end.y) / 2)
        
        // Cubic Bézier curve formula: B(t) = (1-t)³P0 + 3(1-t)²tP1 + 3(1-t)t²P2 + t³P3
        let t: CGFloat = 0.5
        let oneMinusT = 1 - t
        
        let x = oneMinusT * oneMinusT * oneMinusT * start.x +
                3 * oneMinusT * oneMinusT * t * control1.x +
                3 * oneMinusT * t * t * control2.x +
                t * t * t * end.x
        
        let y = oneMinusT * oneMinusT * oneMinusT * start.y +
                3 * oneMinusT * oneMinusT * t * control1.y +
                3 * oneMinusT * t * t * control2.y +
                t * t * t * end.y
        
        return CGPoint(x: x, y: y)
    }
}
