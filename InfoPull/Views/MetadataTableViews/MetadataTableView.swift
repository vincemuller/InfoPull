//
//  MetadataTableView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct MetadataTableView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        !viewModel.tablePresenting ? nil :
        ZStack {
            Color.llightgray
                .ignoresSafeArea()
            VStack (alignment: .center) {
                switch viewModel.selectedModel {
                case .greenFieldsEngineering:
                    Table($viewModel.extractedData) {
                        TableColumn("Filepath") { $row in
                            HStack {
                                TextEditor(text: $row.filename)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        TableColumn("Drawing Number") { $row in
                            TableCellView(editorText: $row.drawingNumber, filename: row.filename, identifier: "drawingNumber")
                        }
                        TableColumn("Drawing Title") { $row in
                            TableCellView(editorText: $row.drawingTitle, filename: row.filename, identifier: "drawingTitle")
                        }
                        TableColumn("Project") { $row in
                            TableCellView(editorText: $row.project, filename: row.filename, identifier: "project")
                        }
                    }
                    .frame(width: width, height: 0.523 * height)
                    .background(Color.black)
                case .brownFieldsEngineering:
                    Table($viewModel.extractedData) {
                        TableColumn("Filepath") { $row in
                            HStack {
                                TextEditor(text: $row.filename)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        TableColumn("Revision") { $row in
                            TableCellView(editorText: $row.revision, filename: row.filename, identifier: "revision")
                        }
                    }
                    .frame(width: width, height: 0.523 * height)
                    .background(Color.black)
                }
                
                OCRQAView(width: width, height: height)
                
                HStack {
                    TableButtonView(width: width, height: height, label: "Hide Table", color: Color.black) {
                        viewModel.tablePresenting.toggle()
                        viewModel.croppedImage = nil
                        viewModel.presentCropImage = false
                    }
                    TableButtonView(width: width, height: height, label: "Export CSV", color: Color.green) {
                        viewModel.exportPromptPresenting.toggle()
                    }
                    TableButtonView(width: width, height: height, label: "Clear Table", color: Color.red) {
                        viewModel.clearTableReset()
                    }
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    MetadataTableView(width: 1470, height: 956)
        .environmentObject(ViewModel())
}
