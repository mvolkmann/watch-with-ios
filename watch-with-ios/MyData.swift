import Foundation

// We must inherit from NSObject in order to use encode/decode these objects.
// NSObject implements the CustomStringConvertible protocol.
// The @objc is necessary to ensure that this class
// has the same "full name" on both the phone and watch.
// See https://stackoverflow.com/questions/69669106/cant-unarchive-a-file-sent-by-watch.
@objc(MyData)
class MyData: NSObject, ObservableObject, NSSecureCoding {
    static var supportsSecureCoding = true
    
    // Override the implementation of description in NSObject.
    override var description: String {
        "MyData: colors = \(colors)"
    }
    
    let id = UUID()
    @Published var colors: [String]
    
    // Override the initializer in NSObject.
    override init() {
        colors = []
    }
    
    // Decodes data.
    required convenience init?(coder: NSCoder) {
        let count = coder.decodeInteger(forKey: "colorCount")
                
        var colors = [String]()
        for _ in 0 ..< count {
            guard let color = coder.decodeObject() as? String else {
                print("MyData.init: failed to decode color")
                return nil
            }
            colors.append(color)
        }
                        
        self.init()
        self.colors = colors
    }
    
    func addColor(_ color: String) {
        colors.append(color)
    }
    
    func deleteColors(at: IndexSet) {
        colors.remove(atOffsets: at)
    }
    
    func encode(with coder: NSCoder) {
        //coder.encode(colors, forKey: "colors")
        coder.encode(colors.count, forKey: "colorCount")
        colors.forEach { coder.encode($0) }
    }
    
    func moveColors(from: IndexSet, to: Int) {
        colors.move(fromOffsets: from, toOffset: to)
    }
}
