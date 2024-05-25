//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/25.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - private functions
private extension RepositoryListViewController {
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear

        // 設定大標題文字屬性
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        
        // 配置導航欄的標準外觀
        navigationController?.navigationBar.standardAppearance = appearance

        // 啟用大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 標題文字
        navigationItem.title = "Repository Search"
    }
    
}
