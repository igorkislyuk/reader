import UIKit

extension String {
    static let empty = ""
}

private extension String {
    static let defaultFileName = "File"
}

final class FileService {

    static let manager = FileManager.default

    static var documentsDirectoryURL: URL {
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first! // need to be fixed
    }

    static func allFiles() -> [String] {
        do {
            let urls = try manager.contentsOfDirectory(at: documentsDirectoryURL,
                                                       includingPropertiesForKeys: nil,
                                                       options: .skipsHiddenFiles)

            let fileNames = urls.map { $0.lastPathComponent }
            return fileNames
        }
        catch {
            debugPrint(#function, error.localizedDescription)
            return []
        }
    }

    static func nextDefaultFileName() -> String {
        let allFilesWithDefaultName = allFiles().filter { $0.contains(String.defaultFileName) }

        let recentNumber = allFilesWithDefaultName
            .map { $0.replacingOccurrences(of: String.defaultFileName, with: String.empty) }
            .compactMap { Int($0) }
            .max() ?? 1

        return String.defaultFileName + String(recentNumber + 1)
    }

    static func copyIfNeeded(file: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: "HP", withExtension: "txt") else {
            debugPrint("No such \(file).\(fileExtension) in Bundle")
            return
        }

        let newUrl = documentsDirectoryURL.appendingPathComponent(file).appendingPathExtension(fileExtension)

        if !manager.fileExists(atPath: newUrl.path) {
            do {
                try FileManager.default.copyItem(at: url, to: newUrl)
            }
            catch {
                debugPrint("Error coping \(file).\(fileExtension)", error.localizedDescription)
            }
        } else {
            debugPrint("File \(file).\(fileExtension) already copied")
        }
    }

}
