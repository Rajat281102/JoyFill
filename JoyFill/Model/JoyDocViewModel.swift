import Foundation
import Combine

class JoyDocViewModel: ObservableObject {
    @Published var joyDocLoading = false
    @Published var joyDocError = ""
    
    // Pulls in the JoyDoc raw JSON data for adding to our ViewController
    func fetchJoyDoc(identifier: String, userAccessToken: String, completion: @escaping ((Any) -> Void)) {
        APIService.fetchJoyDoc(identifier: identifier, userAccessToken: userAccessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.joyDocLoading = false
                    completion(data)
                case .failure(let error):
                    self.joyDocLoading = false
                    self.joyDocError = error.localizedDescription
                    print("Error fetching JoyDoc: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateDocumentChangelogs(identifier: String, userAccessToken: String, docChangeLogs: Any) {
        APIService.updateDocumentChangelogs(identifier: identifier, userAccessToken: userAccessToken, docChangeLogs: docChangeLogs) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let json):
                        print(json)
                    case .failure(let error):
                        print("Error updating changelogs: \(error.localizedDescription)")
                    }
                }
            }
    }
        
    /* Async alternative to loading JoyDoc JSON
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
            let _ = json as? NSDictionary
            self.joyDocJSON = json
        } catch {
            print("Error getting joydoc \(error)")
        }
     */
        
}


