//
//  KeychainHelper.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 04.03.2023.
//

import Foundation

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    private init() {}
    
    func save<T>(_ item: T, service: String, account: String) where T : Codable {
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            print("Fail to encode item for keychain: \(error)")
        }
    }
    
    func read<T>(service: String, account: String, type: T.Type) -> T? where T : Codable {
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            print("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    func save(_ data: Data, service: String, account: String) {
        // Create query
        let query = [
            kSecValueData: data, // Data being saved to the keychain
            kSecClass: kSecClassGenericPassword, // Type of data being saved. Here's a "kSecClassGenericPassword" indicating that the data we are saving is a generic password item
            kSecAttrService: service, // Mandatory when "kSecClass" is set to "kSecClassGenericPassword"
            kSecAttrAccount: account // Mandatory when "kSecClass" is set to "kSecClassGenericPassword"
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
        
        // Checking -25299 error code (equivalent to errSecDuplicateItem)
        if status == errSecDuplicateItem {
            // Item already exist, thus update it
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true,
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}
