import UIKit
import SwiftUI

public enum SwiftUIFocusGuideDirection {
    case left, right, top, bottom
}

public struct SwiftUIFocusGuideDestination: ExpressibleByStringLiteral {

    public enum Position {
        case inside, center, outside
    }

    public let name: String
    public let size: CGFloat
    public let position: Position

    public init(name: String, size: CGFloat = 10.0, position: Position = .outside) {
        self.name = name
        self.size = size
        self.position = position
    }

    public init(stringLiteral value: StringLiteralType) {
        self.name = value
        self.size = 10.0
        self.position = .outside
    }
}

public struct SwiftUIFocusGuide<Content: View>: UIViewControllerRepresentable {

    public typealias Direction = SwiftUIFocusGuideDirection

    public let bag: SwiftUIFocusBag
    public let name: String
    public let destinations: [Direction: SwiftUIFocusGuideDestination]
    public let debug: Bool
    public let content: () -> Content

    public init(
        using bag: SwiftUIFocusBag,
        name: String,
        destinations: [Direction: SwiftUIFocusGuideDestination] = [:],
        debug: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.name = name
        self.destinations = destinations
        self.debug = debug
        self.bag = bag
    }

    public func makeUIViewController(context: Context) -> UIHostingController<Content> {
        context.coordinator.guides = destinations.keys.reduce([:]) {
            var temp = $0
            temp[$1] = UIFocusGuide()
            return temp
        }

        context.coordinator.debugViews = !debug ? [:] : destinations.reduce([:]) {
            var temp = $0
            let debugView = SwiftUIFocusGuideDebugView()
            debugView.title = "from \(name) to \($1.value.name)"
            debugView.direction = $1.key
            temp[$1.key] = debugView
            return temp
        }

        let hostController = UIHostingController(rootView: content(), ignoreSafeArea: true)
        bag.views[name] = hostController.view

        for (direction, focusGuide) in context.coordinator.guides {
            guard let destination = destinations[direction] else { continue }

            hostController.view.addLayoutGuide(focusGuide)
            switch direction {
            case .bottom:
                focusGuide.widthAnchor.constraint(equalTo: hostController.view.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: destination.size).isActive = true
                switch destination.position {
                case .inside:
                    focusGuide.bottomAnchor.constraint(equalTo: hostController.view.bottomAnchor).isActive = true
                case .outside:
                    focusGuide.topAnchor.constraint(equalTo: hostController.view.bottomAnchor).isActive = true
                case .center:
                    focusGuide.topAnchor.constraint(equalTo: hostController.view.bottomAnchor, constant: -(destination.size / 2)).isActive = true
                }
                focusGuide.leftAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
            case .top:
                focusGuide.widthAnchor.constraint(equalTo: hostController.view.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: destination.size).isActive = true
                switch destination.position {
                case .inside:
                    focusGuide.topAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                case .outside:
                    focusGuide.bottomAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                case .center:
                    focusGuide.bottomAnchor.constraint(equalTo: hostController.view.topAnchor, constant: -(destination.size / 2)).isActive = true
                }
                focusGuide.leftAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
            case .left:
                focusGuide.widthAnchor.constraint(equalToConstant: destination.size).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: hostController.view.heightAnchor).isActive = true
                focusGuide.topAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                switch destination.position {
                case .inside:
                    focusGuide.leftAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
                case .outside:
                    focusGuide.rightAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
                case .center:
                    focusGuide.rightAnchor.constraint(equalTo: hostController.view.leftAnchor, constant: -(destination.size / 2)).isActive = true
                }
            case .right:
                focusGuide.widthAnchor.constraint(equalToConstant: destination.size).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: hostController.view.heightAnchor).isActive = true
                focusGuide.topAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                switch destination.position {
                case .inside:
                    focusGuide.rightAnchor.constraint(equalTo: hostController.view.rightAnchor).isActive = true
                case .outside:
                    focusGuide.leftAnchor.constraint(equalTo: hostController.view.rightAnchor).isActive = true
                case .center:
                    focusGuide.leftAnchor.constraint(equalTo: hostController.view.rightAnchor, constant: -(destination.size / 2)).isActive = true
                }
            }

            if let debugView = context.coordinator.debugViews[direction] {
                hostController.view.addSubview(debugView)
            }
        }

        return hostController
    }

    public func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content()

        for (direction, destination) in destinations {
            if let debugView = context.coordinator.debugViews[direction] {
                debugView.frame = context.coordinator.guides[direction]?.layoutFrame ?? .zero
                debugView.isEnabled = bag.isEnabled
            }

            if let destinationView = bag.views[destination.name] {
                context.coordinator.guides[direction]?.preferredFocusEnvironments = bag.isEnabled ? [destinationView] : []
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    public final class Coordinator: NSObject {
        var debugViews: [Direction: SwiftUIFocusGuideDebugView] = [:]
        var guides: [Direction: UIFocusGuide] = [:]
    }
}
