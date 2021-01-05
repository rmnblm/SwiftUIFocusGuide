import SwiftUI

public final class SwiftUIFocusBag: ObservableObject {
    var views: [String: UIView] = [:]
    @Published var isEnabled: Bool = true
}
