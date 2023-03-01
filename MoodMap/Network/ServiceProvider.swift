//
//  ServiceProvider.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation

// MARK: - BaseService
open class BaseService: NSObject {

    unowned let provider: ServiceProviderType

    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}

protocol ServiceProviderType: AnyObject {
    var networkService: NetworkService! { get }
}

public final class ServiceProvider: ServiceProviderType {
    private var locator = SynchronizedDictionary<LazyBox<Any>>()

    var networkService: NetworkService!

    init() {
        self.registerDefaultServices()

        self.networkService = getService()
    }

    public func getService<T>() -> T? {
        let typeStr = "\(T.self)"

        let maybeWrapped = locator.get(key: typeStr)
        guard var wrapped = maybeWrapped else {
            print("Get service error, no service for type: \(typeStr)")
            return nil
        }

        let anyResult: Any
        if case .recipe = wrapped {
            anyResult = wrapped.unwrap()
            locator.putOrUpdate(key: typeStr, value: wrapped)
        } else {
            anyResult = wrapped.get()
        }
        let res = anyResult as? T
        if res == nil {
            print("Get service error. Error casting value: \(anyResult) to type: \(typeStr)")
        }
        return res
    }

    public func register<T>(_ factory: @escaping () -> T) {
        let key = "\(T.self)"
        locator.putOrUpdate(key: key, value: .recipe(factory))
    }

    public func register<T>(_ instance: T) {
        let key = "\(T.self)"
        locator.putOrUpdate(key: key, value: .instance(instance))
    }

    public func unregisterService<T>(_ type: T.Type) {
        let key = "\(T.self)"
        _ = locator.remove(key: key)
    }

    public func registerDefaultServices() {
        self.register(NetworkService(provider: self))
    }
}

