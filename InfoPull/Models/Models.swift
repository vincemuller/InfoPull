import Foundation
import SwiftUI


struct FileData: Identifiable {
    var id = UUID()
    var filename: String
    var drawingNumber: String
    var drawingTitle: String
    var project: String
    var revision: String
}

struct ErrorResponse: Codable {
    var error: String
    var title: String
}

struct Errors: Codable {
    var errors: [ErrorResponse]
}
