// For iOS
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
            print("Perhaps the watch app is not currently running.")
            return
        }

        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: message,
                requiringSecureCoding: true
            )
            connectionProvider.send(message: ["text": bytes])
            print("sent message: \(message)")
            message = ""
        } catch {
            print("ContentView.sendMessage: error \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Text("Phone App").font(.title)
                    NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                        Text("View Colors")
                    }
                    TextField("message", text: $message)
                        .textFieldStyle(.roundedBorder)
                    Button("Send to Watch", action: sendMessage)
                        .buttonStyle(.borderedProminent)
                        .disabled(message.isEmpty)
                    Text("From watch: \(model.message)")
                    Spacer()
                }
            }
        }
        .onAppear {
            connectionProvider.connect()
            let reachable = connectionProvider.session.isReachable
            print("session reachable? \(reachable)")
        }
    }
}
