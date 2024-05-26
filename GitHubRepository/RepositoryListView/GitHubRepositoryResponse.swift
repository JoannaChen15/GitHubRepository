//
//  GitHubRepositoryResponse.swift
//  GitHubRepository
//
//  Created by joanna on 2024/5/26.
//

import Foundation

// MARK: - GitHubRepositoryResponse
struct GitHubRepositoryResponse: Codable {
    let items: [Item]

    enum CodingKeys: CodingKey {
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let fullName: String
    let owner: Owner
    let description: String?
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case owner
        case description
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
