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
            connectionProvider.setup()
        }
    }
}
