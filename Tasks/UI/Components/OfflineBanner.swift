//
//  OfflineBanner.swift
//  Tasks
//
//  Created by Adam Lingham on 05/06/2021.
//

import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        HStack {
            Image(systemName: "icloud.slash")
                .foregroundColor(.white)

            Text("Not connected to the Internet")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .background(Color.yellow)
    }
}

struct OfflineBanner_Previews: PreviewProvider {
    static var previews: some View {
        OfflineBanner()
            .previewLayout(.sizeThatFits)
    }
}
