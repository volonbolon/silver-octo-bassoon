//
//  APIClient.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import Foundation
import VolonbolonKit
import Combine

struct Constant {
    static let apiKey = "f028e6a4de844c87bd361f25bd7b3490"
}

struct APIClient {
    enum Error {
        case addressUnreachable(URL)
        case invalidResponse
    }
    
    let apiQueue = DispatchQueue(label: "Parsing",
                                 qos: .default,
                                 attributes: .concurrent)
    private let apiManager: APIManager
    private let decoder = JSONDecoder()
    
    init(manager: APIManager = Networking.Manager.init()) {
        self.apiManager = manager
    }
    
//    func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, APIClient.Error> {
//        precondition(!storyIDs.isEmpty)
//
//        let storyIDs = Array(storyIDs.prefix(10))
//
//        let initialPublisher = story(id: storyIDs[0])
//        let remainder = Array(storyIDs.dropFirst())
//
//        return remainder
//            .reduce(initialPublisher) { (combined, id) -> AnyPublisher<Story, Error> in
//                return combined.merge(with: story(id: id))
//                    .eraseToAnyPublisher()
//            }
//    }
    
    func stories() -> AnyPublisher<[Story], APIClient.Error> {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(Constant.apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Unable to get the URL")
        }
        let apiQueue = DispatchQueue(label: "Parsing",
                                     qos: .default,
                                     attributes: .concurrent)
        
        return apiManager.loadData(from: url)
            .receive(on: apiQueue)
            .decode(type: StoryContainer.self, decoder: decoder)
            .mapError { error -> APIClient.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(url)
                default:
                    return Error.invalidResponse
                }
            }
            .filter { !$0.articles.isEmpty }
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
}

extension APIClient.Error: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Unable to parse response"
        case .addressUnreachable(let url):
            return "Unable to reach \(url.absoluteURL)"
        }
    }
}

extension APIClient.Error: Identifiable {
    var id: String {
        return localizedDescription
    }
}
