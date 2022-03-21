//
//  APICaller.swift
//  NewsApp
//
//  Created by Дмитрий Стародубцев on 21.03.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string:"https://newsapi.org/v2/everything?q=tesla&from=2022-02-21&sortBy=publishedAt&apiKey=e09f8436b09041c488af1a7f27b01acb")
        
    }
    
    private init() {}
        
        public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
            guard let url = Constants.topHeadlinesURL else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(APIResposnse.self, from: data)
                        print("Articles: \(result.articles.count)")
                        completion(.success(result.articles))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }

// Models

struct APIResposnse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
