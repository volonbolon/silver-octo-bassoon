//
//  ReaderViewModel.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import Foundation
import Combine

class ReaderViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    let apiClient = APIClient()
    
    @Published var error: APIClient.Error? = nil
    @Published var allStories: [Story] = []

    public init() {}
    
    public func fetchStories() {
        apiClient
            .stories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }) { (stories) in
                self.allStories = stories
                self.error = nil
            }
            .store(in: &subscriptions)
    }
}
