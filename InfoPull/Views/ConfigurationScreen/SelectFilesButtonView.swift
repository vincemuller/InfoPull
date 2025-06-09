//
//  SelectFilesButtonView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct SelectFilesButtonView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var label: String = "Select Files"
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button {
            viewModel.selectFilesReset()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .frame(width: 0.17 * width, height: 0.0627 * height)
                Text(label)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
        }
        .buttonStyle(.plain)
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [UTType.init(filenameExtension: "jpg")!, UTType.init(filenameExtension: "png")!],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let files):
                files.forEach { file in
                    // gain access to the directory
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    if !gotAccess { return }
                    // access the directory URL
                    // (read templates in the directory, make a bookmark, etc.)
                    viewModel.selectedFiles = file.path().replacingOccurrences(of: "%20", with: " ")
                    let fileArray = viewModel.selectedFiles.components(separatedBy: "\n")
                    viewModel.filesArray.append(contentsOf: fileArray)
                    file.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }
}

#Preview {
    SelectFilesButtonView(width: 1470, height: 956)
}
