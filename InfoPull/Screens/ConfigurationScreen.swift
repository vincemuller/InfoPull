//
//  ConfigurationScreen.swift
//  InfoPull
//
//  Created by Vince Muller on 6/4/25.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit


struct ConfigurationScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var model: String = ""
    @State var attributeBlock: String = ""
    
    @State var presentCropImage: Bool = false
    
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0

    
    var body: some View {
        
        VStack {
            BannerView(width: width, height: height)
            VStack {
                PullConfigurationView(selectedModel: $viewModel.selectedModel, width: width, height: height)
                VStack {
                    HStack {
                        SelectFilesButtonView(width: width, height: height)
                        ExtractDataButtonView(width: width, height: height)
                    }
                    .padding(.top, 70)
                    viewModel.filesArray.isEmpty ? nil : Text("\(viewModel.filesArray.count) files selected for extraction")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.black)
                        .padding()
                }
            }
            .padding(.top, 50)
            Spacer()
        }
        .background(.llightgray)
        .overlay(alignment: .top, content: {
            !viewModel.tablePresenting ? nil :
            VStack (alignment: .center) {
                
                Table($viewModel.extractedData) {
                    TableColumn("Filepath") { $row in
                        HStack {
                            TextEditor(text: $row.filename)
                                .scrollContentBackground(.hidden)
                        }
                    }
                    TableColumn("Drawing Number") { $row in
                        HStack {
                            TextEditor(text: $row.drawingNumber)
                                .scrollContentBackground(.hidden)
                            Image(systemName: "text.below.photo")
                                .onTapGesture {
                                    viewModel.downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.viewModel.detectTitleBlockSpecificExtract(from: image!, identifier: "drawingNumber")
                                        } catch let error {
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                    TableColumn("Drawing Title") { $row in
                        HStack {
                            TextEditor(text: $row.drawingTitle)
                                .scrollContentBackground(.hidden)
                            Image(systemName: "text.below.photo")
                                .onTapGesture {
                                    viewModel.downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.viewModel.detectTitleBlockSpecificExtract(from: image!, identifier: "drawingTitle")
                                        } catch let error {
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                    TableColumn("Project") { $row in
                        HStack {
                            TextEditor(text: $row.project)
                                .scrollContentBackground(.hidden)
                            Image(systemName: "text.below.photo")
                                .onTapGesture {
                                    viewModel.downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.viewModel.detectTitleBlockSpecificExtract(from: image!, identifier: "project")
                                        } catch let error {
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                }
                .frame(width: width, height: 0.523 * height)
                .background(Color.black)
                Text("OCR Quality Control")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.black)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.llightgray)
                        .stroke(Color.gray)
                        .frame(width: 0.4761 * width, height: 0.2615 * height)
                        .padding(.bottom, 25)
                    if presentCropImage {
                        if let cgImage = viewModel.croppedImage {
                            Image(decorative: cgImage, scale: 1.0, orientation: .up)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 0.46938 * width, height: 0.251 * height)
                                .padding()
                        } else {
                            Text("No image selected")
                                .foregroundStyle(.gray)
                        }
                    }
                }

                HStack {
                    Button {
                        viewModel.tablePresenting.toggle()
                        viewModel.croppedImage = nil
                        presentCropImage = false
                        dump(viewModel.extractedData)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 0.1496 * width, height: 0.0418 * height)
                            Text("Hide Table")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.white)
                        }
                    }
                    .buttonStyle(.plain)
                    Button {
                        viewModel.exportPromptPresenting.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green)
                                .frame(width: 0.1496 * width, height: 0.0418 * height)
                            Text("Export CSV")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.white)
                        }
                    }
                    .buttonStyle(.plain)
                    Button {
                        viewModel.extractedData = []
                        viewModel.filesArray = []
                        viewModel.selectedFiles = ""
                        viewModel.croppedImage = nil
                        presentCropImage = false
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                                .frame(width: 0.1496 * width, height: 0.0418 * height)
                            Text("Clear Table")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.white)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        })
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
        .onAppear {
            if let screen = NSScreen.main {
                let rect = screen.frame
                height = rect.size.height
                width = rect.size.width

                print("Screen width: \(width)")
                print("Screen height: \(height)")
            }
        }
        .alert("Export Complete", isPresented: $viewModel.alertPresenting, actions: {
        }, message: {
            Text("Your extracted data has been successfully exported")
        })
        .alert("Export to CSV", isPresented: $viewModel.exportPromptPresenting) {
            TextField("Enter a name for your file", text: $viewModel.writtenFileName)
            Button("EXPORT", action: {
                viewModel.exportToCSV()
                viewModel.exportPromptPresenting.toggle()
            })
        }
    }
    
}

#Preview {
    ConfigurationScreen()
}
