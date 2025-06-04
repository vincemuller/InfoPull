import Foundation


struct GetArtefactsResponse: Codable {
    let results: [ArtefactResponse]
}

struct ArtefactPreviewResponse: Codable {
    let id: Int
    let url: String
}

struct ArtefactResponse: Codable {
    let id: Int
}

struct Group: Codable {
    var id: Int
    var name: String
}

struct Metadata: Codable {
    var description: String
    var id: Int
    var name: String
}

struct Artefacts: Codable {
    var artefact: ArtefactResponse
}

struct Record: Identifiable {
    var filepath: String = ""
    var sha256: String = ""
    var artefactType: String = ""
    var targetGroup: String = ""
    var workflow: String = ""
    var drawingNum: String = ""
    var drawingTitle: String = ""
    var metadata: [Metadata] = []
    var manifestBatchID: UUID = UUID()
    var id = UUID()
    
    init(filepath: String, sha256: String, artefactType: String, targetGroup: String, workflow: String, drawingNum: String, drawingTitle: String, metadata: [Metadata], manifestBatchID: UUID, id: UUID = UUID()) {
        self.filepath = filepath
        self.sha256 = sha256
        self.artefactType = artefactType
        self.targetGroup = targetGroup
        self.workflow = workflow
        self.drawingNum = drawingNum
        self.drawingTitle = drawingTitle
        self.metadata = metadata
        self.manifestBatchID = manifestBatchID
        self.id = id
    }
}

struct Manifest: Sequence, IteratorProtocol {
    var records: [Record] = []
    
    var count: Int

    mutating func next() -> Int? {
        if count == 0 {
            return nil
        } else {
            defer { count -= 1 }
            return count
        }
    }
    
    init(records: [Record], count: Int) {
        self.records = records
        self.count = count
    }
}

struct ErrorResponse: Codable {
    var error: String
    var title: String
}

struct Errors: Codable {
    var errors: [ErrorResponse]
}
