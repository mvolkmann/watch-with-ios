import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    private let session: WCSession
    
    var colors: [String] = []
    var receivedColors: [String] = []
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
            print("send error: \(error.localizedDescription)")
        }
    }
    
    //TODO: Is this only for watchOS?
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        //TODO: What goes here?
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //TODO: What goes here?
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //TODO: What goes here?
    }
    #endif
    
    func setup() {
        let data = Data()
        data.addColor("Red")
        data.addColor("Green")
        data.addColor("Blue")
        
        NSKeyedArchiver.setClassName("Colors", for: Data.self)
        let bytes = try! NSKeyedArchiver.archivedData(
            withRootObject: data,
            requiringSecureCoding: true
        )
        sendWatchMessage(bytes)
    }
    
    func sendWatchMessage(_ data: Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        // Enforce a time gap of at least a half second
        // between sending messages.
        if lastMessage + 0.5 > currentTime { return }
            
        if session.isReachable {
            print("sendWatchMessage is sending a message")
            let message = ["data", data]
            session.sendMessage(message, replyHandler: nil)
            lastMessage = CFAbsoluteTimeGetCurrent()
        }
    }
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        print("ConnectionProvider receiving a message")
        if message["data"] != nil {
            let messageData = message["data"]
            NSKeyedUnarchiver.setClass(Data.self, forClassName: "Data")
            let loadedData = try! NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [Data.self],
                from: messageData as! Data
            ) as? Data
            receivedData = loadedData!
            print("ConnectionProvider received a message")
        }
    }
}
