import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    static let dataClassName = "MyData"
    static let messageKey = "data"
    
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
            print("ConnectionProvider.connect: WCSession is not supported")
            return
        }
        
        session.activate()
    }
    
    func send(message: [String: Any]) {
        session.sendMessage(message, replyHandler: nil) { error in
            // This is only called when there is an error.
            print("ConnectionProvicer.send error: \(error.localizedDescription)")
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
            print("ConnectionProvider.sendWatchMessage: sending message to watch")
            //TODO: Need to create and send a Dictionary?
            let message = [ConnectionProvider.messageKey: bytes]
            print("ConnectionProvider.sendWatchMessage: message = \(message)")
            
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
        guard let messageData = message[ConnectionProvider.messageKey] else {
            print("ConnectionProvider.session: no message with key \(ConnectionProvider.messageKey) found")
            return
        }
        
        print("ConnectionProvider.session: messageData = \(String(describing: messageData))")
        NSKeyedUnarchiver.setClass(MyData.self, forClassName: ConnectionProvider.dataClassName)
        
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
    
    func setup() {
        data.colors.removeAll()
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
        
        /*
        NSKeyedArchiver.setClassName(
            ConnectionProvider.dataClassName,
            for: MyData.self
        )
        */
        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: data,
                requiringSecureCoding: true
            )
            
            // Demonstrate that we can unarchive the data.
            do {
                // Approach #1
                /*
                let data = try NSKeyedUnarchiver.unarchivedObject(
                     ofClass: MyData.self,
                     from: bytes
                )
                */
                
                // Approach #2
                let newData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bytes) as? MyData
                
                // Approach #3
                /*
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: bytes)
                unarchiver.requiresSecureCoding = true
                let data = try unarchiver.decodeTopLevelObject() as! MyData
                */
                
                print("ConnectionProvider.setup: newData = \(String(describing: newData))")
            } catch {
                print("ConnectionProvider.setup error unarchiving \(error.localizedDescription)")
            }
            
            //sendMessage(bytes)
        } catch {
            print("ConnectionProvider.setup error archiving \(error.localizedDescription)")
        }
    }
}
