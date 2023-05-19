# Navigator


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
