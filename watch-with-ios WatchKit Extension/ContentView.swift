// For watchOS
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    @State var message = ""

    let connectionProvider = ConnectionProvider.instance

    func sendMessage() {
        connectionProvider.sendValue(key: "text", value: message)
        print("sent message: \(message)")
        message = ""
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch App").font(.title)
                NavigationLink(destination: MyDataView()) {
                    Text("View Colors")
                }
                TextField("message", text: $message)
                    //.textFieldStyle(.roundedBorder) // not in watchOS
                Button("Send to Phone", action: sendMessage)
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty)
                Text("From phone: \(model.message)")
            }
        }
        .onAppear {
            if !connectionProvider.session.isReachable {
                connectionProvider.session.activate()
            }
        }
    }
}
