//
//  DisplayTextView.swift
//  JoyFill
//
//  Created by Vikash on 10/02/24.
//

import SwiftUI

struct DisplayTextView: View {
    @State var displayText: String
    var body: some View {
        Text("\(displayText)")
    }
}

#Preview {
    DisplayTextView(displayText: "Hello ")
}
