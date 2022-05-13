import SwiftUI

struct MyDataView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack {
            Text("Color List").font(.title)
            // onDelete and onMove work inside a List,
            // but not inside a ScrollView.
            List {
                ForEach(model.data.colors, id: \.self) { color in
                    Text(color)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                // Swipe from right to left and tap red "X" button.
                .onDelete { model.data.deleteColors(at: $0) }
                // Press for a second and then drag up or down.
                .onMove { model.data.moveColors(from: $0, to: $1) }
            }
        }
    }
}
