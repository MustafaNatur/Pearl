//
//  UserServiceProtocol.swift
//  App
//
//  Created by Mustafa on 30.06.2025.
//
import Foundation

public protocol UserService {
    func getCurrentUsername() -> String
}

public final class UserServiceImpl: UserService {
    public init() {}

    public func getCurrentUsername() -> String {
        // In a real app, this would come from UserDefaults, Keychain, or API
        return "Mustafa"
    }
}
