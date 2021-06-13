//
//  UserDefaultDataStore.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/06/13.
//

import Foundation

struct CardKeyType {
    let selectedText: String
    let tappedCount: String
}

struct UserDefautlsKeys {
    enum CardKeyType: String, UserDefautlsKeyProtocol {
        static let domain: Domain = .cardKeyType
        var id: String { self.rawValue }
        case selectedText
        case tappedCount
    }
}

enum Domain: String {
    case cardKeyType
}

protocol UserDefautlsKeyProtocol {
    static var domain: Domain { get }
    var id: String { get }
    var key: String { get }
}

extension UserDefautlsKeyProtocol {
    var key: String { Self.domain.rawValue + "." + id }
}

final class UserDefault<R: UserDefautlsKeyProtocol> {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set(_ value: Any?, forKey identifier: R) {
        userDefaults.set(value, forKey: identifier.key)
    }
    
    func int(forKey identifier: R) -> Int {
        return userDefaults.integer(forKey: identifier.key)
    }
    
    func string(forKey identifier: R) -> String? {
        return userDefaults.string(forKey: identifier.key)
    }
    
    func remove(forKey identifier: R) {
        userDefaults.removeObject(forKey: identifier.key)
    }
    
}

