extension String {
    static let harryPotterFileName = "harry-potter"
    static let littleWomanFileName = "little-woman"

    static let txtExtension = "txt"

    static let empty = ""
    static let defaultFileName = "File"

    // Contents
    static let noFilesTryAgain = "No files. Try again..."
}

extension String {
    var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
}
