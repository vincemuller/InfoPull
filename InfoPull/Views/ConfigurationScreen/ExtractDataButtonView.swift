//
//  ExtractDataButtonView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct ExtractDataButtonView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button {
            for file in viewModel.filesArray {
                viewModel.downloadLocalImage(from: URL(fileURLWithPath: file)) { image in
                    do {
                        try self.viewModel.detectTitleBlockFullExtract(from: image!, filename: file.lowercased())
                    } catch let error {
                        print(error)
                    }
                }
            }
            withAnimation {
                viewModel.tablePresenting.toggle()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                    .frame(width: 0.17 * width, height: 0.0627 * height)
                Text("Extract Data")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExtractDataButtonView(width: 1470, height: 956)
        .environmentObject(ViewModel())
}
