//
//  BannerView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct BannerView: View {
    
    var title: String = "InfoPull"
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(height: 0.167 * height)
            HStack {
                Image(systemName: "square.and.arrow.down")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 80))
                Text(title)
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(height: 0.0836 * height, alignment: .bottomLeading)
                    .offset(y: 12)
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 70))
                    .offset(y: 12)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    BannerView(width: 1470, height: 956)
}
