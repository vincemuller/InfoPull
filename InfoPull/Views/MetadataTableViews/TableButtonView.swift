//
//  HideTableButtonView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct TableButtonView: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var label: String
    
    var color: Color
    
    var hideFunction: () -> Void
    
    var body: some View {
        Button {
            hideFunction()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 0.1496 * width, height: 0.0418 * height)
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TableButtonView(width: 1470, height: 956, label: "", color: Color.black, hideFunction: {})
}
