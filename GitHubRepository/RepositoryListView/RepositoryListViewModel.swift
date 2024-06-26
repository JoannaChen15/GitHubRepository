//
//  RepositoryListViewModel.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/25.
//

import Foundation

protocol RepositoryListViewModelDelegate: AnyObject {
    func didUpdateRepositories()
}

class RepositoryListViewModel {
    
    weak var delegate: RepositoryListViewModelDelegate?
    
    private(set) var repositories = [Item]() {
        didSet {
            delegate?.didUpdateRepositories()
        }
    }

    func searchRepositories(byName repositoryName: String) {
        // 抓取Repository資料
        networkManager.search(repositoryName: repositoryName) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let repositoryResponse):
                self.repositories = repositoryResponse.items
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetRepositories() {
        repositories = []
    }
    
    private let networkManager = NetworkManager()

}
