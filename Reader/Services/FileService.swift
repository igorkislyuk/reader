import UIKit

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

    static func deleteFile(with lastPathComponent: String) -> Bool {
        let path = documentsDirectoryURL.appendingPathComponent(lastPathComponent).path
        
        do {
            try manager.removeItem(atPath: path)
            return true
        }
        catch {
            return false
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

    static func copyFileIfNeeded(name: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            debugPrint("No such \(name).\(fileExtension) in bundle")
            return
        }

        let newUrl = documentsDirectoryURL.appendingPathComponent(name).appendingPathExtension(fileExtension)

        if !manager.fileExists(atPath: newUrl.path) {
            do {
                try FileManager.default.copyItem(at: url, to: newUrl)
            }
            catch {
                debugPrint("Error coping \(name).\(fileExtension)", error.localizedDescription)
            }
        } else {
            debugPrint("File \(name).\(fileExtension) already copied")
        }
    }
}
