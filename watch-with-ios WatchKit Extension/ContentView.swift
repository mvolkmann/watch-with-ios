// For watchOS
import SwiftUI

struct ContentView: View {
    @State var message = ""

    let connectionProvider: ConnectionProvider
    let model: Model
    let viewModel: ViewModel

    // We need to pass the model in so it can be used in this initializer.
    // If @EnvironmentObject is used to get the model,
    // it isn't available until the body is rendered.
    init(_ model: Model) {
        self.model = model
        connectionProvider = ConnectionProvider(model: model)
        viewModel = ViewModel(connectionProvider: connectionProvider)
    }

    func sendMessage() {
        let session = connectionProvider.session
        if !session.isReachable {
            print("ContentView.sendMessage: session not reachable")
            print("Perhaps the phone app is not currently running.")
            return
        }

        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: message,
                requiringSecureCoding: true
            )
            // TODO: Why does this give the error
            // TODO: "WCSession iOS app not installed"?
            connectionProvider.send(message: ["text": bytes])
        } catch {
            print("ContentView.sendMessage: error \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
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
