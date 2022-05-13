// For iOS
import SwiftUI

struct ContentView: View {
    @State var message = ""

    let connectionProvider: ConnectionProvider
    let viewModel: ViewModel

    init(model: Model) {
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
