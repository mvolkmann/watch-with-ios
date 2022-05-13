import SwiftUI
import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    //@EnvironmentObject var model: Model

    static let dataClassName = "MyData"
    static let messageKey = "data"
    
    let model: Model
    let session: WCSession

    var data = MyData() // used on phone
    var receivedData = MyData() // used on watch
    var lastMessage: CFAbsoluteTime = 0
    
    init(model: Model, session: WCSession = .default) {
        self.model = model
        self.session = session
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

        connect()
    }

    func connect() {
        guard WCSession.isSupported() else {
            // This happens when a watch is running watchOS 1.0.
            print("ConnectionProvider.connect: WCSession is not supported")
            return
        }
        
        session.activate()
    }
    
    func send(message: [String: Any]) {
        session.sendMessage(message, replyHandler: nil) { error in
            // This is only called when there is an error.
            print("ConnectionProvider.send error: \(error.localizedDescription)")
        }
    }
    
    //TODO: Should this only be called on the phone?
    //TODO: Maybe calling it on either platform sends a message to the other.
    func sendMessage(_ bytes: Data) {
        // Enforce a time gap of at least a half second
        // between sending messages.
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime { return }
            
        if session.isReachable {
            // The WCSession sendMessage method requires
            // a Dictionary with String keys and Any values.
            let message = [ConnectionProvider.messageKey: bytes]
            
            session.sendMessage(message, replyHandler: nil) { error in
                // This is only called when there is an error.
                print("ConnectionProvider.sendMessage error: \(error)")
            }
            lastMessage = CFAbsoluteTimeGetCurrent()
        } else {
            print("ConnectionProvider.sendMessage: session not reachable")
            print("Perhaps the watch app is not currently running.")
        }
    }
    
    // This is used on the phone and the watch.
    // This is called when a connection between
    // the phone and watch is established.
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("phone/watch connection was activated")
    }
    
    #if os(iOS)
    // This is only called on the phone.
    // It is called when there is a temporary disconnection
    // between the phone and watch.
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("phone/watch connection became inactive")
    }
    
    // This is only called on the phone.
    // It is called when there is a permanent disconnection
    // between the phone and watch.
    func sessionDidDeactivate(_ session: WCSession) {
        print("phone/watch connection was deactivated")
    }
    #endif
    
    // This is called when a message is received.
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        do {
            if let bytes = message["text"] as? Data {
                let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bytes)
                let text = object as! String
                print("text = \(text)")
                Task
                model.message = text
            }
            
            if let bytes = message[ConnectionProvider.messageKey] as? Data {
                let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bytes)
                receivedData = object as! MyData
                print("ConnectionProvider: receivedData = \(receivedData)")
            }
        } catch {
            print("ConnectionProvider.session error unarchiving \(error.localizedDescription)")
        }
    }
    
    func setup() {
        data.colors.removeAll()
        
        let format = DateFormatter()
        format.timeStyle = .medium
        format.dateStyle = .medium
        let dateString = format.string(from: Date())
        print("ConnectionProvider.setup: dateString = \(dateString)")
        data.addColor(dateString)
        
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
        
        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: data,
                requiringSecureCoding: true
            )
            
            // Demonstrate that we can unarchive the data.
            //let newData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bytes) as? MyData
            //print("ConnectionProvider.setup: newData = \(String(describing: newData))")
            
            sendMessage(bytes)
        } catch {
            print("ConnectionProvider.setup error archiving \(error.localizedDescription)")
        }
    }
}
