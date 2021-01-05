import SwiftUI
import SwiftUIFocusGuide

struct ComplexEampleView: View {

    @StateObject var focusBag = SwiftUIFocusBag()

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Button(action: {}, label: {
                        Text("Button")
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Text("Button")
                    })
                }
                .addFocusGuide(using: focusBag, name: "TopRow", destinations: [.bottom: .init(name: "MiddleRow", size: 20, position: .inside)], debug: true)
                .border(Color.blue, width: 1)

                Spacer()

                HStack {
                    Button(action: {}, label: {
                        Text("Button")
                    })
                }
                .addFocusGuide(using: focusBag, name: "MiddleRow", destinations: [.top: "TopRow", .bottom: "BottomRow"], debug: true)
                .border(Color.blue, width: 1)

                Spacer()

                HStack {
                    Button(action: {}, label: {
                        Text("Button")
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Text("Button")
                    })
                }
                .addFocusGuide(using: focusBag, name: "BottomRow", destinations: [.top: .init(name: "MiddleRow", size: 40, position: .inside)], debug: true)
                .border(Color.blue, width: 1)
            }
            .addFocusGuide(using: focusBag, name: "RightEdge", destinations: [.right: "ButtonStack"], debug: true)
            .border(Color.blue, width: 1)

            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(Array(0...50), id: \.self) { index in
                            Button(action: {}, label: {
                                Text("Button \(index)")
                            })
                        }
                    }
                    .padding(32)
                }
            }
            .addFocusGuide(using: focusBag, name: "ButtonStack", destinations: [.left: .init(name: "TopRow", position: .inside)], debug: true)
            .border(Color.blue, width: 1)
        }
    }
}

struct ComplexEampleView_Previews: PreviewProvider {
    static var previews: some View {
        ComplexEampleView()
    }
}
