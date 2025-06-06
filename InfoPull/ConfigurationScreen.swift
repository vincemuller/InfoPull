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
                    ZStack(alignment: .leading) {
                        if model.isEmpty {
                            Text("")
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                        TextField("", text: $model)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.leading)
                    }
                    .padding(.vertical, 4)
                    .frame(width: 300, height: 40)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.gray)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .padding(.vertical, 20)
                HStack {
                    Text("Attribute Group:")
                        .frame(width: 160, alignment: .leading)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.gray)
                    ZStack(alignment: .leading) {
                        if attributeBlock.isEmpty {
                            Text("")
                                .font(.system(size: 20))
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                        TextField("", text: $attributeBlock)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.leading)
                    }
                    .padding(.vertical, 4)
                    .frame(width: 300, height: 40)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.gray)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
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
                                        try self.networkManager.detectTitleBlock(from: image!, filename: file.lowercased())
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
            VStack (alignment: .center, spacing: 25) {
                
                Table(networkManager.extractedData) {
                    TableColumn("Filepath", value: \.filename)
                    TableColumn("Drawing Number", value: \.drawingNumber)
                    TableColumn("Drawing Title", value: \.drawingTitle)
                    TableColumn("Project", value: \.project)
                    TableColumn("Revision", value: \.revision)
                }
                .frame(width: 1500, height: 650)
                .background(Color.black)
                HStack {
                    Button {
                        tablePresenting.toggle()
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
                if let cgImage = networkManager.croppedImage {
                    Image(decorative: cgImage, scale: 1.0, orientation: .up)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding()
                } else {
                    Text("No image selected")
                        .foregroundStyle(.gray)
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
    
    
//    Task {
//        try await networkManager.getArtefactsByGroup()
//        await networkManager.getPreviewImages()
//    }
}

#Preview {
    ConfigurationScreen()
}
