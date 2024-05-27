//
//  NetworkManager.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/25.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func search(repositoryName: String, completion: @escaping (Result<GitHubRepositoryResponse,Error>) -> Void) {
        let parameters: [String : Any] = [
            "q": repositoryName
        ]
        
        AF.request("https://api.github.com/search/repositories", method: .get, parameters: parameters).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let searchResponse = try JSONDecoder().decode(GitHubRepositoryResponse.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Network request failed with error: \(error)")
            }
            
        }
    }
    
}
