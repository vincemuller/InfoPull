//
//  Enums.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import Foundation
import CreateML
import Vision
import CoreML


enum SelectedModel: Identifiable, CaseIterable {
    case general, revision
    var id: Self { self }
    var label: String {
        switch self {
        case .general:
            return "General Attributes Model"
        case .revision:
            return "Revision Attributes Model"
        }
    }
    var model: VNCoreMLModel {
        get throws {
            switch self {
            case .general:
                return try VNCoreMLModel(for: InfoPull_Model(configuration: .init()).model)
            case .revision:
                return try VNCoreMLModel(for: InfoPullRevModel_(configuration: .init()).model)
            }
        }
    }
    
    var attributes: [String] {
        switch self {
        case .general:
            return ["Drawing Number","Drawing Title","Project"]
        case .revision:
            return ["Revision"]
        }
    }
}
