//
//  JoyDocViewModel.swift
//  JoyFill
//
//  Created by Vikash on 06/02/24.
//

import Foundation

class JoyDocViewModel: ObservableObject {
    @Published var joyDocLoading = false
    @Published var joyDocError = ""
    
    func fetchJoyDoc(identifier: String, userAccessToken: String, completion: @escaping ((Any) -> Void)) {
        
        guard let url = URL(string: "\(Constants.baseURL)/\(identifier)") else {
            print("Invalid json url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.joyDocLoading = false
                    }
                    
                    completion(data)
                } catch {
                    print("Error fetching documents: \(error.localizedDescription )")
                }
            }
        }.resume()
    }
    
    func updateDocumentChangelogs(identifier: String, userAccessToken: String, docChangeLogs: Any) {
        do {
            guard let url = URL(string: "\(Constants.baseURL)/\(identifier)/changelogs") else {
                print("Invalid json url")
                return
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: docChangeLogs, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating changelogs: \(error)")
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    let _ = json as? NSDictionary
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
}
