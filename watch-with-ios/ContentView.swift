// For iOS
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
            Form {
                VStack {
                    Text("Phone App").font(.title)
                    NavigationLink(destination: MyDataView()) {
                        Text("View Colors")
                    }
                    Button("Connect") {
                        connectionProvider.connect()
                    }
                        .buttonStyle(.borderedProminent)
                    Button("Reachable?") {
                        print("reachable? \(connectionProvider.session.isReachable)")
                    }
                        .buttonStyle(.borderedProminent)
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
        /*
        .onAppear {
            // This won't work if the watchOS app isn't running yet.
            connectionProvider.connect()
        }
        */
    }
}
