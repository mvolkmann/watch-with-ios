import SwiftUI

struct MyDataView: View {
    @EnvironmentObject var model: Model
    @ObservedObject var viewModel: ViewModel
    @State var data = MyData()
    
    var body: some View {
        VStack {
            Text("Color List").font(.title)
            // onDelete and onMove work inside a List,
            // but not inside a ScrollView.
            List {
                //ForEach(data.colors, id: \.self) { color in
                ForEach(model.colors, id: \.self) { color in
                    Text(color)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                // Swipe from right to left and tap red "X" button.
                .onDelete { data.deleteColors(at: $0) }
                // Press for a second and then drag up or down.
                .onMove { data.moveColors(from: $0, to: $1) }
            }
        }
        .onAppear() {
            viewModel.connectionProvider.connect()
            
            // Should this only be called in the iOS app?
            // I'm getting an error which this is called that says
            // "WCSession iOS app not installed".
            //viewModel.connectionProvider.setup()
            data = viewModel.connectionProvider.receivedData
            
            //print("MyDataView on watch: data = \(data)")
        }
    }
}
