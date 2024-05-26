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
        
        viewModel.delegate = self
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
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
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
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }
        searchBar.placeholder = "請輸入關鍵字搜尋"
        searchBar.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.width.centerX.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "RepositoryListTableViewCell")
    }
}
