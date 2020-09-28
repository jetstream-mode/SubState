//
//  UserCache.swift
//  SubState
//
//  Created by Josh Kneedler on 9/18/20.
//

import Foundation
import SwiftUI

protocol UserCache {
    associatedtype Storage
    
    var items: [Storage] { get }
    
    var cacheCount: Int { get }
    
    func add(item: Storage)
    
    func removeItem(at offsets: IndexSet)
    
    func displayItems() -> [Storage]
    
    func save()
}

struct LogEntryData: Equatable, Hashable, Identifiable, Codable {

    var id = UUID()
    let loggedTrack: Tracks
    let loggedUserText: String
    var hasTwitterPosted: Bool = false
    var hasVisitedBandSite: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LogEntryData, rhs: LogEntryData) -> Bool {
        return lhs.id == rhs.id && lhs.loggedTrack.id == rhs.loggedTrack.id
    }
}

class LogEntries: UserCache, ObservableObject {
    //@Published private(set) var items: [LogEntryData]
    @Published var items: [LogEntryData]
    
    static let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([LogEntryData].self, from: data) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    var cacheCount: Int {
        items.count
    }

    
    func add(item: LogEntryData) {
        items.append(item)
        save()
    }
    
    func removeItem(at offsets: IndexSet)  {
        //items.remove(atOffsets: <#T##IndexSet#>)
        //items.remove(object: item)
        items.remove(atOffsets: offsets)
        save()
    }
    
    func displayItems() -> [LogEntryData] {
        items
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}


