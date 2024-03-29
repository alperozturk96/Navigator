# Navigator

Navigator is a versatile and powerful library that makes SwiftUI app navigation a breeze. It provides a collection of easy-to-use methods to push, pop, and customize your navigation stack effortlessly.

- Push Any View: With just a single line of code, you can push any view onto your navigation stack.
- Push Any View And Set Navigation Bar Title you can also apply Navigation Animation
- Present Any View Modally
- Pop Back To Specific View ( Navigation Bar Title must be set )
- Pop Back To Root View: Effortlessly pop back to your app's root view.
- Pop Back To Previous View: Go back to the previous view.
- Remove All Views In Stack: Clear your navigation stack and start fresh.
- Set Custom Navigation Stack: Create a custom navigation stack to your app's needs.


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
struct ExampleApp: App {
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
