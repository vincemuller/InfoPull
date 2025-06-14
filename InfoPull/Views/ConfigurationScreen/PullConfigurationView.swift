//
//  PullConfigurationView.swift
//  InfoPull
//
//  Created by Vince Muller on 6/8/25.
//

import SwiftUI

struct PullConfigurationView: View {
    
    @Binding var selectedModel: SelectedModel
    
    let title: String = "Pull Configuration"
    let modelTitle: String = "Model:"
    let attributeGroupTitle: String = "Attributes:"
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Text(title)
            .font(.system(size: 40, weight: .semibold))
            .foregroundStyle(Color.gray)
            .padding(.bottom, 40)
        HStack {
            Text(modelTitle)
                .frame(width: 0.1088 * width, alignment: .leading)
                .font(.system(size: 20))
                .foregroundStyle(Color.gray)
            Picker("", selection: $selectedModel) {
                ForEach(SelectedModel.allCases, id: \.self) { model in
                    Text(model.label)
                        .foregroundStyle(Color.black)
                        .onTapGesture {
                            self.selectedModel = model
                        }
                }
            }
            .frame(width: 0.2108 * width, height: 0.04184 * height, alignment: .leading)
        }
        .padding(.vertical, 20)
        HStack (alignment: .top) {
            Text(attributeGroupTitle)
                .frame(width: 0.1088 * width, alignment: .leading)
                .font(.system(size: 20))
                .foregroundStyle(Color.gray)
            VStack (alignment: .leading){
                ForEach(selectedModel.attributes, id: \.self) { attribute in
                    Text(attribute)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.black)
                        .offset(y: 2)
                }
            }
            .padding(.leading, 10)
            .padding(.bottom)
            .frame(width: 0.204 * width, height: 90, alignment: .topLeading)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .stroke(Color.gray.opacity(0.5))
            }
            .offset(y: 2)
        }
    }
}

#Preview {
    PullConfigurationView(selectedModel: .constant(.general), width: 1470, height: 956)
}
