//
//  DocumentViewModel.swift
//  JoyFill
//
//  Created by Vikash on 04/02/24.
//

import Foundation
import SwiftyJSON

class DocumentViewModel: ObservableObject {
    var JoyDocModel = JoyDocViewModel()
    
    @Published var documents: [DocumentModel] = []
    @Published var submissions: [DocumentModel] = []
    
    @Published var userAccessToken = Constants.userAccessToken
    
    
    func fetchTemplateList() {
        guard let url = URL(string: "\(Constants.baseURL)?limit=25&page=1&type=document&stage=published") else {
            return
        }
        
        print("Url Is \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let documents = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    
                    print("Retrieved \(documents.data.count) documents")
                    
                    DispatchQueue.main.async {
                        self.documents = documents.data
                    }
                }  catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchDocumentSubmissions(identifier: String) {
        guard let url = URL(string: "\(Constants.baseURL)?template=\(identifier)&page=1&limit=25") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let submissions = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    
                    print("Retrieved \(submissions.data.count) document submissions")
                    
                    DispatchQueue.main.async {
                        self.submissions = submissions.data
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    func createDocumentSubmission(identifier: String, completion: @escaping ((Any) -> Void)) {
        JoyDocModel.fetchJoyDoc(identifier: identifier, userAccessToken: userAccessToken, completion: { joyDocJSON in
            
            print("First Loaded createDocumentSubmission joyDocJSON ", joyDocJSON)
            print("First Loaded createDocumentSubmission identifier ", identifier)
            
            guard let url = URL(string: "\(Constants.baseURL)") else {
                print("Invalid json url")
                return
            }
            
            var request = URLRequest(url: url)
            var json = JSON(joyDocJSON)
            
            json.dictionaryObject?.removeValue(forKey: "_id")
            json.dictionaryObject?.removeValue(forKey: "createdOn")
            json.dictionaryObject?.removeValue(forKey: "deleted")
            json.dictionaryObject?.removeValue(forKey: "categories")
            json.dictionaryObject?.removeValue(forKey: "stage")
            json.dictionaryObject?.removeValue(forKey: "identifier")
            json.dictionaryObject?.removeValue(forKey: "metadata")
            json.dictionaryObject?.updateValue("document", forKey: "type")
            json.dictionaryObject?.updateValue(identifier, forKey: "template")
            json.dictionaryObject?.updateValue(identifier, forKey: "source")
            
            let jsonData = json.rawString(options: .fragmentsAllowed)?.data(using: .utf8)
            
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("Bearer \(self.userAccessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error creating submission: \(error)")
                } else if let data = data {
                    let jsonRes = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    let _ = jsonRes as? NSDictionary
                    
                    print("COMPLETE CREATED DOC jsonRes: ", jsonRes ?? "TEST")
                    
                    completion(jsonRes!)
                }
            }.resume()
        })
    }
}
