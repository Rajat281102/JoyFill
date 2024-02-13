//
//  MultiSelectionView.swift
//  JoyFill
//
//  Created by Babblu Bhaiya on 10/02/24.
//

import SwiftUI

// Select multiple options

struct MultiSelectionView: View {
    var options: [String]
    
    var body: some View {
        VStack {
            List(options, id: \.self) { option in
                MultiSelection(option: option)
            }
        }
    }
}

struct MultiSelection: View {
    var option: String
    var body: some View {
        VStack {
            HStack {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(systemName: "record.circle.fill")
                            Text(option)
                                .foregroundStyle(.black)
                        }
                        
                    })
                Spacer()
            }
        }
    }
}

#Preview {
    MultiSelectionView(options: [])
}


//                Image(systemName: "record.circle.fill")
