//
//  FormView.swift
//  JoyFill
//
//  Created by Vikash on 06/02/24.
//

import SwiftUI

struct FormView: View {
    let identifier: String
    @State var data: JoyDoc?
    
    var body: some View {
            VStack{
                
            }
            .onAppear{
                APIService().fetchJoyDoc(identifier: identifier) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let joyDocStruct = try JSONDecoder().decode(JoyDoc.self, from: data)
                            
                            // It will prevent tasks to perform on main thread
                            DispatchQueue.main.async {
                                self.data = joyDocStruct
                                pageIndex = 0
                                fetchDataFromJoyDoc()
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                    
                }
            }
    }
}

#Preview {
    FormView(identifier: "dfdf")
}
