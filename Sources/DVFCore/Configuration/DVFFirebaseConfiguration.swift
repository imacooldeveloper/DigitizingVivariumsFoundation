import Foundation

public struct DVFFirebaseConfiguration: Sendable, Codable {
    public let projectID: String
    public let apiKey: String
    public let authDomain: String
    public let storageBucket: String
    public let messagingSenderID: String
    public let appID: String
    
    public init(
        projectID: String,
        apiKey: String,
        authDomain: String,
        storageBucket: String,
        messagingSenderID: String,
        appID: String
    ) {
        self.projectID = projectID
        self.apiKey = apiKey
        self.authDomain = authDomain
        self.storageBucket = storageBucket
        self.messagingSenderID = messagingSenderID
        self.appID = appID
    }
} 