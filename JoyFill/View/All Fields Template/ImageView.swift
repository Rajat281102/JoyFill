//
//  ImageView.swift
//  JoyFill
//
//  Created by Babblu Bhaiya on 10/02/24.
//

import SwiftUI

// Logo or Graphic

struct ImageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Image")
            Button(action: {
                print("Button Tapped")
            }, label: {
                Image("UploadImageBorder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
            })
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ImageView()
}
