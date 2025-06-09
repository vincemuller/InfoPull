//
//  TableCellView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct TableCellView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var editorText: String
    var filename: String
    var identifier: String
    
    var body: some View {
        HStack {
            TextEditor(text: $editorText)
                .scrollContentBackground(.hidden)
            Image(systemName: "text.below.photo")
                .onTapGesture {
                    viewModel.downloadLocalImage(from: URL(fileURLWithPath: filename)) { image in
                        viewModel.presentCropImage = true
                        do {
                            try self.viewModel.detectTitleBlockSpecificExtract(from: image!, identifier: self.identifier)
                        } catch let error {
                            print(error)
                        }
                    }
                }
        }
    }
}

#Preview {
    TableCellView(editorText: .constant(""), filename: "OCRExtractData", identifier: "drawingTitle")
        .environmentObject(ViewModel())
}
