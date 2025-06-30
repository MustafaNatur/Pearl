//
//  UserServiceProtocol.swift
//  App
//
//  Created by Mustafa on 30.06.2025.
//


protocol UserService {
    func getCurrentUsername() -> String
}

final class UserServiceImpl: UserService {
    func getCurrentUsername() -> String {
        // In a real app, this would come from UserDefaults, Keychain, or API
        return "Mustafa"
    }
}
