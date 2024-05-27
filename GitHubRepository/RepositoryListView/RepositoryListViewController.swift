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
        viewModel.delegate = self
        
        // 訂閱鍵盤彈出和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
        // 取消tableViewCell選取狀態
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 添加點擊手勢
        guard tapGesture == nil else { return }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 移除點擊手勢
        guard let tapGesture else { return }
        view.removeGestureRecognizer(tapGesture)
        self.tapGesture = nil
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    @objc func refreshRepositoryList() {
        if searchBar.text == "" {
            let controller = UIAlertController(title: "Oops!", message: "The data couldn't be read because it is missing.", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                guard let self else { return }
                self.tableView.refreshControl?.endRefreshing()
            }
            controller.addAction(continueAction)
            present(controller, animated: true)
        } else {
            searchRepositories()
        }
    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - private properties
    private let viewModel = RepositoryListViewModel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var tapGesture: UITapGestureRecognizer?
    private let refreshControl = UIRefreshControl()

}

// MARK: - UISearchBarDelegate
extension RepositoryListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchRepositories()
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.resetRepositories()
        }
    }
}

// MARK: - RepositoryListViewModelDelegate
extension RepositoryListViewController: RepositoryListViewModelDelegate {
    func didUpdateRepositories() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
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
        tableView.tableHeaderView = searchBar
        searchBar.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.width.equalTo(tableView)
        }
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
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshRepositoryList), for: .valueChanged)
    }
    
    func searchRepositories() {
        let searchTerm = searchBar.text ?? ""
        viewModel.searchRepositories(byName: searchTerm)
    }
}
