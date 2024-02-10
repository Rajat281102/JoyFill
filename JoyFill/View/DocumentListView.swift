//
//  DocumentListView.swift
//  JoyFill
//
//  Created by Vikash on 04/02/24.
//

import SwiftUI

struct DocumentListView: View {
    @ObservedObject var documentsViewModel = DocumentViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Templates List")
                List {
                    ForEach(documentsViewModel.documents) { document in
                        NavigationLink {
                            DocumentSubmissionsList(identifier: document.identifier, name: document.name)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "doc")
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                    Text(document.name)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear() {
                documentsViewModel.fetchTemplateList()
                print("view present")
            }
        }
    }
}

#Preview {
    DocumentListView()
}
