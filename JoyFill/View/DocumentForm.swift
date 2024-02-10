//
//  DocumentForm.swift
//  JoyFill
//
//  Created by Vikash on 06/02/24.
//

import SwiftUI

struct DocumentForm: View {
    var identifier: String
    var userAccessToken: String
    
    var body: some View {
        Group {
            DocumentJoyDoc(identifier: identifier, userAccessToken: userAccessToken)
        }
    }
}

#Preview {
    DocumentForm(identifier: "dfdf", userAccessToken: "dfdf")
}
