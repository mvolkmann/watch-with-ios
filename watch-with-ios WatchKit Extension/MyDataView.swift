import SwiftUI

struct MyDataView: View {
    @ObservedObject var viewModel: ViewModel
    @State var data = MyData()
    
    /*
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        print("MyDataView: viewModel = \(viewModel)")
    }
    */
    
    var body: some View {
        VStack {
            Text("Color List").font(.title)
            // onDelete and onMove work inside a List,
            // but not inside a ScrollView.
            List {
                ForEach(data.colors, id: \.self) { color in
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
            //viewModel.connectionProvider.setup()
            data = viewModel.connectionProvider.receivedData
            print("MyDataView onAppear: data = \(data)")
        }
    }
}
