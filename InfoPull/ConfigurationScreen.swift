//
//  ConfigurationScreen.swift
//  InfoPull
//
//  Created by Vince Muller on 6/4/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ConfigurationScreen: View {
    
    @StateObject var networkManager = NetworkManager()
    
    @State var model: String = ""
    @State var attributeBlock: String = ""
    @State var showFileImporter: Bool = false
    @State var selectedFiles: String = ""
    @State var filesArray: [String] = []
    @State var i: CGImage?
    
    @State var tablePresenting: Bool = false
    @State var presentCropImage: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 160)
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 80))
                    Text("InfoPull")
                        .font(.system(size: 60, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(height: 80, alignment: .bottomLeading)
                        .offset(y: 12)
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 70))
                        .offset(y: 12)
                }
                .padding(.horizontal, 30)
            }
            VStack {
                Text("Pull Configuration")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, 40)
                HStack {
                    Text("Model:")
                        .frame(width: 160, alignment: .leading)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.gray)
                    Picker("", selection: $networkManager.selectedModel) {
                        ForEach(SelectedModel.allCases, id: \.self) { model in
                            Text(model.label)
                                .foregroundStyle(Color.black)
                                .onTapGesture {
                                    self.networkManager.selectedModel = model
                                }
                        }
                    }
                    .frame(width: 310, height: 40, alignment: .leading)
                }
                .padding(.vertical, 20)
                HStack (alignment: .top) {
                    Text("Attribute Group:")
                        .frame(width: 160, alignment: .leading)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.gray)
                    VStack (alignment: .leading){
                        ForEach(networkManager.selectedModel.attributes, id: \.self) { attribute in
                            Text(attribute)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.bottom)
                    .frame(width: 300, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .stroke(Color.gray.opacity(0.5))
                    }
                    .offset(y: 2)
                }
                VStack {
                    HStack {
                        Button {
                            showFileImporter = true
                            filesArray = []
                            selectedFiles = ""
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black)
                                    .frame(width: 250, height: 60)
                                Text("Select Files")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .buttonStyle(.plain)
                        Button {
                            for file in filesArray {
                                downloadLocalImage(from: URL(fileURLWithPath: file)) { image in
                                    do {
                                        try self.networkManager.detectTitleBlockFullExtract(from: image!, filename: file.lowercased())
                                    } catch let error {
                                        print(error)
                                    }
                                }
                            }
                            tablePresenting.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green)
                                    .frame(width: 250, height: 60)
                                Text("Extract Data")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 70)
                    filesArray.isEmpty ? nil : Text("\(filesArray.count) files selected for extraction")
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
            !tablePresenting ? nil :
            VStack (alignment: .center) {
                
                Table($networkManager.extractedData) {
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
                                    downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.networkManager.detectTitleBlockSpecificExtract(from: image!, identifier: "drawingNumber")
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
                                    downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.networkManager.detectTitleBlockSpecificExtract(from: image!, identifier: "drawingTitle")
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
                                    downloadLocalImage(from: URL(fileURLWithPath: row.filename)) { image in
                                        presentCropImage = true
                                        do {
                                            try self.networkManager.detectTitleBlockSpecificExtract(from: image!, identifier: "project")
                                        } catch let error {
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                }
                .frame(width: 1500, height: 500)
                .background(Color.black)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.llightgray)
                        .stroke(Color.gray)
                        .frame(width: 700, height: 250)
                        .padding(.top)
                        .padding(.bottom, 25)
                    if presentCropImage {
                        if let cgImage = networkManager.croppedImage {
                            Image(decorative: cgImage, scale: 1.0, orientation: .up)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 690, height: 240)
                                .padding()
                        } else {
                            Text("No image selected")
                                .foregroundStyle(.gray)
                        }
                    }
                }

                HStack {
                    Button {
                        tablePresenting.toggle()
                        networkManager.croppedImage = nil
                        presentCropImage = false
                        dump(networkManager.extractedData)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 250, height: 40)
                            Text("Hide Table")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.white)
                        }
                    }
                    .buttonStyle(.plain)
                    Button {
                        networkManager.extractedData = []
                        filesArray = []
                        selectedFiles = ""
                        networkManager.croppedImage = nil
                        presentCropImage = false
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                                .frame(width: 250, height: 40)
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
            isPresented: $showFileImporter,
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
                    selectedFiles = file.path().replacingOccurrences(of: "%20", with: " ")
                    let fileArray = selectedFiles.components(separatedBy: "\n")
                    filesArray.append(contentsOf: fileArray)
                    file.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }
    
    func downloadLocalImage(from url: URL, completion: @escaping (CGImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let nsImage = NSImage(data: data),
                  let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(cgImage)
            }
        }.resume()
    }
}

#Preview {
    ConfigurationScreen()
}
