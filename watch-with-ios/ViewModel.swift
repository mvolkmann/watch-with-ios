import Foundation

final class ViewModel: ObservableObject {
    private(set) var connectionProvider: ConnectionProvider

    init(connectionProvider: ConnectionProvider) {
        self.connectionProvider = connectionProvider
        connectionProvider.connect()
    }
}
