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
    
    func sendWatchMessage(_ message: Data) {
        // Enforce a time gap of at least a half second
        // between sending messages.
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime { return }
            
        if session.isReachable {
            print("ConnectionProvider.sendWatchMessage: sending message")
            let message = ["data": message]
            session.sendMessage(message, replyHandler: nil)
            lastMessage = CFAbsoluteTimeGetCurrent()
        } else {
            print("ConnectionProvider.sendWatchMessage: session not reachable")
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
        print("ConnectionProvider receiving a message")
        if message["data"] != nil {
            let messageData = message["data"]
            NSKeyedUnarchiver.setClass(MyData.self, forClassName: "MyData")
            let loadedData = try! NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [MyData.self],
                from: messageData as! Data
            ) as? MyData
            receivedData = loadedData!
            print("ConnectionProvider received a message")
        }
    }
    
    func setup() {
        data = MyData()
        data.addColor("Red")
        data.addColor("Green")
        data.addColor("Blue")
        
        NSKeyedArchiver.setClassName("MyData", for: MyData.self)
        let bytes = try! NSKeyedArchiver.archivedData(
            withRootObject: data,
            requiringSecureCoding: true
        )
        sendWatchMessage(bytes)
    }
}
