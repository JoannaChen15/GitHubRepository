//
//  ReposityListTableViewCell.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/26.
//

import UIKit

class ReposityListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ReposityListTableViewCell")
        configureUI()
        
        //test
        ownerIconImageView.backgroundColor = .blue
        repositoryNameLabel.text = "openstack/swift"
        descriptionLabel.text = "OpenStack Storage (Swift). Mirror of code maintained at opendev.org."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private properties
    private let ownerIconImageView = UIImageView()
    private let repositoryNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let outerStackView = UIStackView()
    private let innerStackView = UIStackView()
    
}


// MARK: - private functions
private extension ReposityListTableViewCell {
    func configureUI() {
        configureOuterStackView()
        configureOwnerIcon()
        configureInnerStackView()
        configureRepositoryNameLabel()
        configureDescriptionLabel()
    }
    
    func configureOuterStackView() {
        contentView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 16
    }
    
    func configureOwnerIcon() {
        outerStackView.addArrangedSubview(ownerIconImageView)
        ownerIconImageView.snp.makeConstraints {
            $0.size.equalTo(80)
        }
    }
    
    func configureInnerStackView() {
        outerStackView.addArrangedSubview(innerStackView)
        innerStackView.axis = .vertical
        innerStackView.alignment = .leading
        innerStackView.spacing = 4
    }

    
    func configureRepositoryNameLabel() {
        innerStackView.addArrangedSubview(repositoryNameLabel)
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    func configureDescriptionLabel() {
        innerStackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 0
    }
}
