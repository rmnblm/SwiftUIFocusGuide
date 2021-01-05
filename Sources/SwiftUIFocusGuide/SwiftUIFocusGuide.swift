import SwiftUI

public enum SwiftUIFocusGuideDirection {
    case left, right, top, bottom
}

public struct SwiftUIFocusGuide<Content: View>: UIViewControllerRepresentable {

    public typealias Direction = SwiftUIFocusGuideDirection

    public let bag: SwiftUIFocusBag
    public let name: String
    public let destinations: [Direction: String]
    public let debug: Bool
    public let content: () -> Content

    public init(using bag: SwiftUIFocusBag, name: String, destinations: [Direction: String] = [:], debug: Bool = false, @ViewBuilder content: @escaping () -> Content) {
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
            debugView.title = "from \(name) to \($1.value)"
            temp[$1.key] = debugView
            return temp
        }

        let hostController = UIHostingController(rootView: content(), ignoreSafeArea: true)
        bag.views[name] = hostController.view

        for (direction, focusGuide) in context.coordinator.guides {
            hostController.view.addLayoutGuide(focusGuide)
            switch direction {
            case .bottom:
                focusGuide.widthAnchor.constraint(equalTo: hostController.view.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.topAnchor.constraint(equalTo: hostController.view.bottomAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
            case .top:
                focusGuide.widthAnchor.constraint(equalTo: hostController.view.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.bottomAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
            case .left:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: hostController.view.heightAnchor).isActive = true
                focusGuide.topAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                focusGuide.rightAnchor.constraint(equalTo: hostController.view.leftAnchor).isActive = true
            case .right:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: hostController.view.heightAnchor).isActive = true
                focusGuide.topAnchor.constraint(equalTo: hostController.view.topAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: hostController.view.rightAnchor).isActive = true
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

            if let destinationView = bag.views[destination] {
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
