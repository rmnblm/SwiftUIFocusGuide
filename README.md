# SwiftUIFocusGuide
The missing UIFocusGuide for SwiftUI

## Why?
Although Apple added some limited focus support in 2020 ([WWDC20-10042](https://developer.apple.com/videos/play/wwdc2020/10042/)), it is still lacking behind it's [`UIFocusGuide`](https://developer.apple.com/documentation/uikit/uifocusguide) counterpart. 

## Requirements
* iOS 14.0 or greater
* tvOS 14.0 or greater
* macOS 10.15 or greater

## Usage

``` swift
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
```

The above example looks like this:

![Simple Example](Images/simple_example.png)

Passing `debug: true`  visualizes the focus guides on the screen.

A more complex example can be founde in the Example tvOS app.

## How it works
`SwiftUIFocusGuide`  wraps its content in a `UIHostingController` and setups a focus guide for each direction. It then sets the `preferredFocusEnvironments` according to the specified destination by name. 

``` swift
public func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
    ...
    for (direction, destination) in destinations {
        ... 
        if let destinationView = bag.views[destination.name] {
            context.coordinator.guides[direction]?.preferredFocusEnvironments = bag.isEnabled ? [destinationView] : []
        }
    }
}
```

## Limitations
Using `UIHostingController` has its caveats: It does not wrap its intrinsic content size. As a result, the focus guide takes up all available space. You would have to set a fixed size with the `frame()` modifier and set its intrinsic content size manually.

See:
* https://stackoverflow.com/questions/58399123/uihostingcontroller-should-expand-to-fit-contents
* https://stackoverflow.com/questions/60663679/how-to-resize-uihostingcontroller-to-wrap-its-swiftui-view
* https://stackoverflow.com/questions/61547810/uiviewrepresentable-and-its-contents-intrinsic-size
