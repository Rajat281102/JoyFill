//
//  ApiService.swift
//  JoyfillExample
//
//  
//
import Foundation
import Combine
import SwiftyJSON

enum JoyfillAPI {
    case document(identifier: String? = nil)
    case template(identifier: String? = nil)
    
    var endPoint: URL {
        
        switch self {
        case .document(identifier: let identifier):
            if let identifier = identifier {
                return URL(string: "\(Constants.baseURL)?document=\(identifier)&page=1&limit=25")!
            }
            return URL(string: "\(Constants.baseURL)?&page=1&limit=25")!
        case .template(identifier: let identifier):
            if let identifier = identifier {
                return URL(string: "\(Constants.baseURL)?template=\(identifier)&page=1&limit=25")!
            }
            return URL(string: "\(Constants.baseURL)?&page=1&limit=25")!
        }
        
    }
}

class APIService {
    private var JoyDocModel = JoyDocViewModel()
    private let accessToken: String
    
    init(accessToken: String, JoyDocModel: JoyDocViewModel = JoyDocViewModel()) {
        self.accessToken = accessToken
        self.JoyDocModel = JoyDocModel
    }
    
    private func urlRequest(type: JoyfillAPI) -> URLRequest {
        var request = URLRequest(url: type.endPoint)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    func makeAPICall(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
            .resume()
    }
    
    
    
    func fetchDocuments(completion: @escaping (Result<[Document], Error>) -> Void) {
        let request = urlRequest(type: .document())
        makeAPICall(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let documents = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    completion(.success(documents.data))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? APIError.unknownError))
            }
        }
    }
    
    func fetchDocumentSubmissions(identifier: String, completion: @escaping (Result<[Document], Error>) -> Void) {
                
        let request = urlRequest(type: .template(identifier: identifier))
        makeAPICall(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let documents = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    completion(.success(documents.data))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? APIError.unknownError))
            }
        }
    }
    
    static func createDocumentSubmission(joyDocModel: JoyDocViewModel,identifier: String, userAccessToken: String, completion: @escaping (Result<Any, Error>) -> Void) {
            
        joyDocModel.fetchJoyDoc(identifier: identifier, userAccessToken: userAccessToken) { joyDocJSON in
                
                guard let url = URL(string: "\(Constants.baseURL)") else {
                    completion(.failure(APIError.invalidURL))
                    return
                }
                
                var request = URLRequest(url: url)
                var json = JSON(joyDocJSON)

                // Using SwiftyJson we remove some of the uneeded keys, specifically changing the "type" to "document"
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
                request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data {
                        do {
                            let jsonRes = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                            completion(.success(jsonRes))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
            }
        }
    
    static func fetchJoyDoc(identifier: String, userAccessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let url = URL(string: "\(Constants.baseURL)/\(identifier)") else {
                completion(.failure(APIError.invalidURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error ?? APIError.unknownError))
                    }
                }
            }.resume()
        }
    
    static func updateDocumentChangelogs(identifier: String, userAccessToken: String, docChangeLogs: Any, completion: @escaping (Result<Any, Error>) -> Void) {
        do {
            guard let url = URL(string: "\(Constants.baseURL)/\(identifier)/changelogs") else {
                completion(.failure(APIError.invalidURL))
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
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                        completion(.success(json))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

enum APIError: Error {
    case invalidURL
    case unknownError
}
