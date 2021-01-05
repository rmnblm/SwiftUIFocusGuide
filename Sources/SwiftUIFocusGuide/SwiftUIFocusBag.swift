import SwiftUI

public final class SwiftUIFocusBag: ObservableObject {
    public var views: [String: UIView] = [:]
    @Published public var isEnabled: Bool = true

    public init() { }
}
