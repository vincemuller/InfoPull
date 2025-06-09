//
//  ConfigurationScreen.swift
//  InfoPull
//
//  Created by Vince Muller on 6/4/25.
//

import SwiftUI
import AppKit


struct ConfigurationScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var model: String = ""
    @State var attributeBlock: String = ""
    
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
            MetadataTableView(width: width, height: height)
        })
        
        .onAppear {
            if let screen = NSScreen.main {
                let rect = screen.frame
                height = rect.size.height
                width = rect.size.width
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
