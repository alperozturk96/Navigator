# Navigator

- Push Any View
- Pop Back To Specific View
- Pop Back To Root View
- Pop Back To Previous View
- Remove All Views In Stack
- Set Custom Navigation Stack

  -   ```swift
      let viewD = ViewD()
      let viewE = ViewE()
      Navigator.setStack([viewD.getVC(), viewE.getVC()])

## Example Demo
https://github.com/alperozturk96/Navigator/assets/67455295/234cc94a-a5a9-485d-85c9-1a5e796a71e0



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
