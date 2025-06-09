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
    case greenFieldsEngineering, brownFieldsEngineering
    var id: Self { self }
    var label: String {
        switch self {
        case .greenFieldsEngineering:
            return "Green Fields Engineering Title Block"
        case .brownFieldsEngineering:
            return "Brown Fields Engineering Title Block"
        }
    }
    var model: VNCoreMLModel {
        get throws {
            switch self {
            case .greenFieldsEngineering:
                return try VNCoreMLModel(for: InfoPull_Model(configuration: .init()).model)
            case .brownFieldsEngineering:
                return try VNCoreMLModel(for: MLModel())
            }
        }
    }
    
    var attributes: [String] {
        switch self {
        case .greenFieldsEngineering:
            return ["Drawing Number","Drawing Title","Project"]
        case .brownFieldsEngineering:
            return ["Revision","Status","Drawn By"]
        }
    }
}
