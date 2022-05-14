import SwiftUI
import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    static let instance = ConnectionProvider()
    
    let model = Model.instance
    let session = WCSession.default

    // We cannot use @EnvironmentObject to get access to the model here
    // because that only works in View subclasses.
    // That is why it is passed to the initializer.
    override init() {
        super.init()
        self.session.delegate = self

        /*
         #if os(iOS)
             print("ConnectionProvider initialized on phone")
         #endif

         #if os(watchOS)
             print("ConnectionProvider initialized on watch")
         #endif
         */

        //connect()
    }

    func connect() {
        guard WCSession.isSupported() else {
            // This happens when a watch is running watchOS 1.0.
            print("ConnectionProvider.connect: WCSession is not supported")
            return
        }
        print("ConnectionProvider: calling activate")
        session.activate()
    }
    
    func extractValue(key: String, message: [String: Any]) -> Any? {
        do {
            if let bytes = message[key] as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bytes) as Any
            }
        } catch {
            print("ConnectionProvider.extractObject error \(error.localizedDescription)")
        }
        return nil
    }

    func sendValue(key: String, value: Any) {
        if !session.isReachable {
            connect()
        }
        if session.isReachable {
            do {
                let bytes = try NSKeyedArchiver.archivedData(
                    withRootObject: value,
                    requiringSecureCoding: true
                )

                // The WCSession sendMessage method requires
                // a Dictionary with String keys and Any values.
                let message = [key: bytes]
                print("ConnectionProvider.sendValue: calling sendMessage")
                session.sendMessage(message, replyHandler: nil) { error in
                    // This is only called when there is an error.
                    print("ConnectionProvider.sendMessage error: \(error)")
                }
            } catch {
                print("ConnectionProvider.sendObject: error \(error.localizedDescription)")
            }
        } else {
            print("ConnectionProvider.sendObject: session not reachable")
            print("Perhaps the companion app is not currently running.")
        }
    }

    // This is used on the phone and the watch.
    // It is called when a connection between
    // the phone and watch is established.
    func session(
        _: WCSession,
        activationDidCompleteWith _: WCSessionActivationState,
        error _: Error?
    ) {
        print("phone/watch connection was activated")
        print("session reachable? \(session.isReachable)")
    }

    #if os(iOS)
        // This is only called on the phone.
        // It is called when there is a temporary disconnection
        // between the phone and watch.
        func sessionDidBecomeInactive(_: WCSession) {
            print("phone/watch connection became inactive")
        }

        // This is only called on the phone.
        // It is called when there is a permanent disconnection
        // between the phone and watch.
        func sessionDidDeactivate(_: WCSession) {
            print("phone/watch connection was deactivated")
        }
    #endif

    // This is called when a message is received.
    func session(
        _: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        if let value = extractValue(key: "text", message: message) {
            let text = value as! String
            print("ConnectionProvider.session: text = \(text)")
            // Update the model on the main thread.
            Task {
                await MainActor.run { model.message = text }
            }
        }

        if let value = extractValue(key: "data", message: message) {
            let data = value as! MyData
            print("ConnectionProvider.session: data = \(data)")
            // Update the model on the main thread.
            Task {
                await MainActor.run { model.data = data }
            }
        }
    }

    func setup() {
        print("ConnectionProvider.setup: entered")
        let data = model.data
        data.colors.removeAll()

        data.addColor(timestamp())

        data.addColor("Red")
        data.addColor("Orange")
        data.addColor("Yellow")
        data.addColor("Green")
        data.addColor("Blue")
        data.addColor("Purple")
        data.addColor("White")
        data.addColor("Gray")
        data.addColor("Black")
        data.addColor("Brown")
        data.addColor("Tan")
        data.addColor("Pink")
        data.addColor("Turquoise")
        print("model colors = \(model.data.colors)")

        print("ConnectionProvider.setup: calling sendValue")
        sendValue(key: "data", value: data)
    }
    
    func timestamp() -> String {
        let format = DateFormatter()
        format.timeStyle = .medium
        format.dateStyle = .medium
        return format.string(from: Date())
    }
}
