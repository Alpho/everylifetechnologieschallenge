//
//  ToggleButton.swift
//  Tasks
//
//  Created by Adam Lingham on 07/06/2021.
//

import SwiftUI

struct ToggleButton: View {
    let imageName: String

    @Binding var isChecked: Bool

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            Image(imageName)
                .resizable()
                .frame(width: 36, height: 36)
        }
        .background(isChecked ? Color.gray : Color.clear)
    }
}

struct ToggleButton_Previews: PreviewProvider {
    private struct PreviewContainerView: View {
        @State private var isChecked = false

        var body: some View {
            ToggleButton(imageName: "general", isChecked: $isChecked)
        }
    }

    static var previews: some View {
        ForEach(
            ColorScheme.allCases,
            id: \.self,
            content: PreviewContainerView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme
        )
    }
}
