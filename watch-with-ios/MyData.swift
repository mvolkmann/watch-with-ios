import Foundation

class MyData: NSObject, ObservableObject, NSSecureCoding {
    static var supportsSecureCoding = true
    
    let id = UUID()
    @Published var colors: [String]
    
    override init() {
        colors = []
    }
    
    // Decodes data.
    required convenience init?(coder: NSCoder) {
        guard let colors = coder.decodeObject(forKey: "colors") as? [String]
        else { return nil }
        
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
        coder.encode(colors, forKey: "colors")
    }
    
    func moveColors(from: IndexSet, to: Int) {
        colors.move(fromOffsets: from, toOffset: to)
    }
}
