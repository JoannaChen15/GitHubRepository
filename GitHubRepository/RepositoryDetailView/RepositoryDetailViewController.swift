//
//  RepositoryDetailViewController.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/26.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - private properties
    private let outerStackView = UIStackView()
    private let middleStackView = UIStackView()
    private let innerStackView = UIStackView()
    private let ownerIconImageView = UIImageView()
    private let repositoryNameLabel = UILabel()
    private let programLanguageLabel = UILabel()
    private let starsLabel = UILabel()
    private let watchersLabel = UILabel()
    private let forksLabel = UILabel()
    private let issuesLabel = UILabel()
    
}

private extension RepositoryDetailViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureOuterStackView()
        configureOwnerIconImageView()
        configureRepositoryNameLabel()
        configureMiddleStackView()
        configureProgramLanguageLabel()
        configureInnerStackView()
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
        
        // 設定返回按鈕文字、顏色
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureOuterStackView() {
        view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        outerStackView.axis = .vertical
        outerStackView.alignment = .fill
        outerStackView.distribution = .fill
        outerStackView.spacing = 48
    }
    
    func configureOwnerIconImageView() {
        outerStackView.addArrangedSubview(ownerIconImageView)
        ownerIconImageView.snp.makeConstraints {
            $0.height.equalTo(ownerIconImageView.snp.width)
        }
    }
    
    func configureRepositoryNameLabel() {
        outerStackView.addArrangedSubview(repositoryNameLabel)
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 24)
        repositoryNameLabel.textAlignment = .center
        repositoryNameLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    func configureMiddleStackView() {
        outerStackView.addArrangedSubview(middleStackView)
        middleStackView.axis = .horizontal
        middleStackView.distribution = .fill
        middleStackView.alignment = .top
    }
    
    func configureProgramLanguageLabel() {
        middleStackView.addArrangedSubview(programLanguageLabel)
        programLanguageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    func configureInnerStackView() {
        middleStackView.addArrangedSubview(innerStackView)
        
        innerStackView.axis = .vertical
        innerStackView.alignment = .trailing
        innerStackView.distribution = .equalSpacing
        innerStackView.spacing = 16

        innerStackView.addArrangedSubview(starsLabel)
        innerStackView.addArrangedSubview(watchersLabel)
        innerStackView.addArrangedSubview(forksLabel)
        innerStackView.addArrangedSubview(issuesLabel)
        
        for subview in innerStackView.arrangedSubviews {
            if case let label as UILabel = subview {
                label.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
}
