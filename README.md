# Navigator

- Push Any View
- Pop Back To Any View
- Pop Back To Previous View
- Remove All Views In Stack
- Set Custom Navigation Stack

## Example Demo

https://github.com/alperozturk96/Navigator/assets/67455295/7e069e36-049d-490c-b8bf-0a81a7f41252

## Example Usage

```swift
import SwiftUI
import Navigator

@main
struct nv_testApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ViewA()
            }
        }
    }
}


struct ViewA: View {
    var body: some View {
        Text("Navigate To B")
            .onTapGesture {
                Navigator.push(ViewB())
            }
    }
}


struct ViewB: View {
    var body: some View {
        Text("Navigate To C")
            .onTapGesture {
                Navigator.push(ViewC())
            }
    }
}


struct ViewC: View {
    var body: some View {
        Text("Pop Back To A")
            .onTapGesture {
                Navigator.popToRoot()
            }
    }
}
```
