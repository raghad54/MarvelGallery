//
//  NetworkError.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import Foundation

enum NetworkError: Error {
    case badServerResponse
    case decodingError
    case unknownError
    
    static func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            return .badServerResponse
        } else if error is DecodingError {
            return .decodingError
        } else {
            return .unknownError
        }
    }
}
