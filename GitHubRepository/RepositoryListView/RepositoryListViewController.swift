//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/25.
//

import UIKit
import SnapKit

class RepositoryListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
        viewModel.delegate = self
    }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    // MARK: - private properties
    private let viewModel = RepositoryListViewModel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()

}

extension RepositoryListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        viewModel.searchRepositories(byName: searchTerm)
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.resetRepositories()
        }
    }
}

extension RepositoryListViewController: RepositoryListViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

extension RepositoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListTableViewCell", for: indexPath) as! RepositoryListTableViewCell
        cell.setupWith(viewModel: viewModel.repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryDetailViewController = RepositoryDetailViewController()
        let detailViewModel = RepositoryDetailViewModel(
            repositoryModel: viewModel.repositories[indexPath.row]
        )
        repositoryDetailViewController.setupWith(viewModel: detailViewModel)
        navigationController?.pushViewController(repositoryDetailViewController, animated: true)
    }
}

// MARK: - private functions
private extension RepositoryListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureSearchBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        
        // 設置導航欄滾動至邊界時的外觀
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.backgroundColor = .white
        scrollEdgeAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // 設置導航欄的標準外觀
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundColor = .black.withAlphaComponent(0.9)
        
        // 配置導航欄的標準外觀
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        
        // 啟用大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 標題文字
        title = "Repository Search"
    }
    
    func configureSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        tableView.tableHeaderView = searchBar
        searchBar.placeholder = "請輸入關鍵字搜尋"
        searchBar.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "RepositoryListTableViewCell")
    }
}
