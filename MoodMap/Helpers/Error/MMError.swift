//
//  MMError.swift
//  MoodMap
//
//  Created by ANTON DOBRYNIN on 19.05.2023.
//

import Foundation

enum MMError: LocalizedError, Equatable {
    
    enum MMDefinedError: String {
        
        case unknownError                   = "Неизвестная ошибка"
        case parseError                     = "Ошибка обработки ответа сервера"
        
        case emptyOperationId               = "Отсутствует токен операции"
        case emptyToken                     = "Отсутствует токен сессии"
        case emptyAuthToken                 = "Отсутствует токен авторизации"
        case emptyRegisterToken             = "Отсутствует токен регистрации"
        
        case accessDenied                   = "Access denied!"
        case tokenRevoked                   = "X-Auth-Token is revoked"
        case tokenUndefined                 = "Token is undefined"
        case invalidToken                   = "Invalid token!"
        case expiredToken                   = "jwtauth: token is expired"
        
        case cannotFindIdInToken            = "cannot find id in token"
        case codeWasntAsked                 = "code wasn't asked"
        
        case invalidInputData               = "invalid input data"
        
        case incorrectChallengeResponse     = "challenge response is incorrect"
        case incorrectPassword              = "password is incorrect"
        case tooManyRetries                 = "too many attempts"
        
        case pageNotFound                   = "not found"
        
        
        case bometryIsDenied                = "User has denied the use of biometry for this app."
        
        case phoneUndefined                 = "phoneUndefined"
        
        case internalDatabaseError          = "internal database error"
        
        case attemptsLimitExceeded          = "attempts limit exceeded"
        
        case enterTheCorrectData            = "enter the correct data"
        
        case paymentslessThanAmout          = "payments less than amount"
        
        case incorrectSmsCode               = "cannot check code: incorrect code"
        
        case invalidSmsCode                 = "invalid sms code"
        
        case invalidEmailCode               = "invalid email code"
        
        case noContent                      = "no content"
        
        var localizedDescription: String {
            switch self {
            case .accessDenied:             return "В доступе отказано"
            case .tokenRevoked:             return "Токен авторизации истёк"
            case .tokenUndefined:           return "Токен не найден"
            case .invalidToken,
                 .expiredToken:             return "Токен сессии истёк"
                
            case .cannotFindIdInToken:      return "Мы не нашли ваш Id в токене, пожалуйста, напишите нам в поддержку, чтобы мы решили данную проблему"
            case .invalidInputData:         return "Проверьте введенные данные"
                
            case .incorrectChallengeResponse:
                                            return "Не удается войти с помощью биометрии. Войдите с помощью пароля"
            case .incorrectPassword:        return "Неверный пароль"
            
            case .tooManyRetries:           return "Слишком много запросов. Попробуйте попытку через 30 сек."
                                                
            case .internalDatabaseError:    return "Внутренняя ошибка базы данных!"
            
            case .attemptsLimitExceeded:    return "Много неудачных попыток, попробуйте позже"
                
            case .enterTheCorrectData:      return "Данные неверны, проверьте правильность ввода"
                                
            case .pageNotFound:             return "Страница не найдена"
                
            case .noContent:                return "Данных нет"
                
            default:
                return self.rawValue
            }
        }

    }
    
    case defined(MMDefinedError)
    case other(String)
    case undefined
    
    var localizedDescription: String {
        switch self {
        case let .defined(error):   return error.localizedDescription
        case let .other(message):   return message
        case .undefined:            return "Неизвестная ошибка"
        }
    }
    
    init(message: String?) {
        if let message = message {
            if let definedError = MMDefinedError(rawValue: message) {
                self = .defined(definedError)
            } else {
                self = .other(message)
            }
        } else {
            self = .undefined
        }
    }
}
