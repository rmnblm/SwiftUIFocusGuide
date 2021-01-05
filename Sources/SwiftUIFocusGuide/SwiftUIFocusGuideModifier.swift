import SwiftUI

public struct SwiftUIFocusGuideModifier: ViewModifier {

    @ObservedObject public var focusBag: SwiftUIFocusBag
    public let name: String
    public let destinations: [SwiftUIFocusGuideDirection: SwiftUIFocusGuideDestination]
    public let debug: Bool

    public func body(content: Content) -> some View {
        SwiftUIFocusGuide(using: focusBag, name: name, destinations: destinations, debug: debug) {
            content
        }
    }
}

extension View {
    public func addFocusGuide(using bag: SwiftUIFocusBag, name: String, destinations: [SwiftUIFocusGuideDirection: SwiftUIFocusGuideDestination], debug: Bool = false) -> some View {
        return self.modifier(SwiftUIFocusGuideModifier(focusBag: bag, name: name, destinations: destinations, debug: debug))
    }
}
