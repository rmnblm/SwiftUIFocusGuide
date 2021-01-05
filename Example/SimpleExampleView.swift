import SwiftUI
import SwiftUIFocusGuide

struct SimpleExampleView: View {

    @StateObject var focusBag = SwiftUIFocusBag()

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Button(action: {}, label: { Text("Button") })
                Spacer()
            }
            .addFocusGuide(using: focusBag, name: "Left", destinations: [.right: "Right"], debug: true)

            VStack {
                Spacer()
                Button(action: {}, label: { Text("Button") })
            }
            .addFocusGuide(using: focusBag, name: "Right", destinations: [.left: "Left"], debug: true)
        }
    }
}

struct SimpleExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleExampleView()
    }
}
