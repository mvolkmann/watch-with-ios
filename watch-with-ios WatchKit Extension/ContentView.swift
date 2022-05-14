// For watchOS
import SwiftUI

struct ContentView: View {
    @State var message = ""

    let connectionProvider: ConnectionProvider
    let model: Model

    // We need to pass the model in so it can be used in this initializer.
    // If @EnvironmentObject is used to get the model,
    // it isn't available until the body is rendered.
    init(_ model: Model) {
        self.model = model
        connectionProvider = ConnectionProvider(model: model)
        model.data.connectionProvider = connectionProvider
    }

    func sendMessage() {
        let session = connectionProvider.session
        if session.isReachable {
            connectionProvider.sendValue(key: "text", value: message)
        } else {
            print("ContentView.sendMessage: session not reachable")
            print("Perhaps the phone app is not currently running.")
        }
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
            connectionProvider.connect()
            let reachable = connectionProvider.session.isReachable
            print("session reachable? \(reachable)")
        }
    }
}
