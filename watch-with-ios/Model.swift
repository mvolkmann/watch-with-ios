import SwiftUI

class Model: ObservableObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    let id = UUID()
    
    @Published var colors: [String]
    
    init() {
        colors = [
            "Red",
            "Orange",
            "Yellow",
            "Green",
            "Blue",
            "Purple",
            "White",
            "Gray",
            "Black",
            "Brown",
            "Tan",
            "Pink",
            "Turquoise"
        ]
    }
    
    // Decodes data.
    required convenience init?(coder: NSCoder) {
        guard let colors = coder.decodeObject(forKey: "colors") as? [String]
        else { return nil }
        
        self.init()
        self.colors = colors
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(colors, forKey: "colors")
    }
    
    func deleteColors(at: IndexSet) {
        print("Model.deleteColor entered")
        /*
        for index in at.reversed() {
            colors.remove(at: index)
        }
        */
        colors.remove(atOffsets: at)
    }
    
    func moveColors(from: IndexSet, to: Int) {
        print("Model.moveColor entered")
        colors.move(fromOffsets: from, toOffset: to)
    }
}
