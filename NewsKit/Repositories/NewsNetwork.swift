//
//  NewsNetwork.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import Foundation
import Combine

protocol NetworkSession {
    func get(from url: URL) -> AnyPublisher<Data, URLError>
}

extension URLSession: NetworkSession {
    func get(from url: URL) -> AnyPublisher<Data, URLError> {
        let apiQueue = DispatchQueue(label: "API",
                                     qos: .default,
                                     attributes: .concurrent)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: apiQueue)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}

protocol APIManager {
    func loadData(from url: URL) -> AnyPublisher<Data, Networking.Error>
}

class Networking {
    /// Responsible for handling all networking calls.
    /// Warning: Must be created before using any public APIs
    
    public enum Error: LocalizedError {
        case urlError(URLError)
        case invalidResponse
        
        public var errorDescription: String? {
            switch self {
            case .urlError(let urlError):
                return urlError.localizedDescription
            case .invalidResponse:
                return "Invalid Response"
            }
        }
    }
    
    public class Manager: APIManager {
        internal var session: NetworkSession = URLSession.shared
        public init() {}
        
        /// Retrieves data from the specied location
        /// - Parameters:
        ///   - url: Location of the  resource to retrieve
        ///   - completionHandler: Either data or an error
        public func loadData(from url: URL) -> AnyPublisher<Data, Networking.Error> {
            return session.get(from: url)
                .mapError { (error) -> Networking.Error in
                    return .urlError(error)
                }
                .eraseToAnyPublisher()
        }
    }
}
