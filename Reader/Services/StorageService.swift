import Foundation

final class StorageService {
    static let shared = StorageService()

    private init() {}

    var strings: [String] = []

}
