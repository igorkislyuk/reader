extension String {
    static let harryPotterFileName = "harry-potter"
    static let txtExtension = "txt"
    static let empty = ""
    static let defaultFileName = "File"
}

extension String {
    var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
}
