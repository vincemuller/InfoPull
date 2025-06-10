//
//  OCRQAView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct OCRQAView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Text("OCR Quality Control")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.black)
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.llightgray)
                .stroke(Color.gray)
                .frame(width: 0.4761 * width, height: 0.2615 * height)
            if viewModel.presentCropImage {
                if let cgImage = viewModel.croppedImage {
                    Image(decorative: cgImage, scale: 1.0, orientation: .up)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 0.40 * width, height: 0.24 * height)
                        .padding()
                } else {
                    Text("No image selected")
                        .foregroundStyle(.gray)
                        .frame(width: 0.40 * width, height: 0.24 * height)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    OCRQAView(width: 1470, height: 956)
        .environmentObject(ViewModel())
}
