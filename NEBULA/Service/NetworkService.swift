//
//  NetworkService.swift
//  NEBULA
//
//  Created by Admin on 2026-08-31.
//
 
import Foundation

struct NetworkService {
    func fetch<T: Decodable>(_ requete: URLRequest, as type: T.Type) async throws -> T {
        let (donnees, reponse) = try await URLSession.shared.data(for: requete)

        guard let reponseHTTP = reponse as? HTTPURLResponse,
              (200...299).contains(reponseHTTP.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: donnees)
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
