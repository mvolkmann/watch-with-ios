import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    private let session: WCSession
    
    var data = MyData() // used on phone
    var receivedData = MyData() // used on watch
    var lastMessage: CFAbsoluteTime = 0
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        
        #if os(iOS)
            print("ConnectionProvider initialized on phone")
        #endif
    
        #if os(watchOS)
            print("ConnectionProvider initialized on watch")
        #endif

        connect()
    }

    func connect() {
        guard WCSession.isSupported() else {
            // This happens when a watch is running watchOS 1.0.
            print("WCSession is not supported")
            return
        }
        
        session.activate()
    }

    func send(message: [String: Any]) {
        session.sendMessage(message, replyHandler: nil) { error in
            // This is only called when there is an error.
            print("send error: \(error.localizedDescription)")
        }
    }
    
    //TODO: Should this only be called on the phone?
    //TODO: Maybe calling it on either platform sends a message to the other.
    func sendWatchMessage(_ message: Data) {
        // Enforce a time gap of at least a half second
        // between sending messages.
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime { return }
            
        if session.isReachable {
            print("ConnectionProvider.sendWatchMessage: sending message to watch")
            let message = ["data": message]
            session.sendMessage(message, replyHandler: nil)
            lastMessage = CFAbsoluteTimeGetCurrent()
            print("ConnectionProvider.sendWatchMessage: sent message to watch")
        } else {
            print("ConnectionProvider.sendWatchMessage: session not reachable")
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
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        print("ConnectionProvider.session receiving a message")
        if message["data"] != nil {
            let messageData = message["data"]
            print("ConnectionProvider.session: messageData = \(String(describing: messageData))")
            
            NSKeyedUnarchiver.setClass(MyData.self, forClassName: "MyData")
            
            do {
                print("ConnectionProvider.session calling unarchiveObject")
                let object = try NSKeyedUnarchiver.unarchivedObject(
                    ofClasses: [MyData.self],
                    from: messageData as! Data
                )
                print("ConnectionProvider.session returned from unarchiveObject")
                print("ConnectionProvider.session: object = \(String(describing: object))")
                let data = object as? MyData
                print("ConnectionProvider.session: data = \(String(describing: data))")
                receivedData = data!
                print("ConnectionProvider.session received a message")
            } catch {
                print("ConnectionProvider.session error unarchiving \(error.localizedDescription)")
            }
        }
    }
    
    func setup() {
        data = MyData()
        data.addColor("Red")
        data.addColor("Green")
        data.addColor("Blue")
        
        NSKeyedArchiver.setClassName("MyData", for: MyData.self)
        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: data,
                requiringSecureCoding: true
            )
            sendWatchMessage(bytes)
        } catch {
            print("ConnectionProvider.setup error archiving \(error.localizedDescription)")
        }
    }
}
