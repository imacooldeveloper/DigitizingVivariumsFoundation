public class DVFUIService: ObservableObject {
    public let themeManager: DVFThemeManager
    public let componentLibrary: DVFComponentLibrary
    
    public init() {
        self.themeManager = DVFThemeManager()
        self.componentLibrary = DVFComponentLibrary()
    }
} 