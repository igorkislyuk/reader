extension NavigationService {
    static func createFilesViewController() -> FilesViewController {
        return FilesViewController(viewModel: FilesViewModel())
    }
}
