//
//  SelectFilesButtonView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

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
    }
}

#Preview {
    SelectFilesButtonView(width: 1470, height: 956)
}
