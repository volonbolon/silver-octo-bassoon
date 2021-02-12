//
//  News.swift
//  News
//
//  Created by Ariel Rodriguez on 11/02/2021.
//

import Foundation
import Combine

struct StoryContainer: Codable {
    let articles: [Story]
}

struct Story: Codable, Identifiable {
    var id: String {
        return url
    }
    let title: String
    let author: String?
    let url: String
}

//extension Story: Comparable {
//    public static func <(lhs: Story, rhs: Story) -> Bool {
//        return lhs.time > rhs.time
//    }
//}

extension Story: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\n\(title)\nby \(author)\n\(url)\n-----"
    }
}
