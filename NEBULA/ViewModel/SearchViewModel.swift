//
//  SearchViewModel.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//
 
import Foundation

@Observable
class SearchViewModel {
    var texteSearch = ""
    var resultats: [ObjetCeleste] = []
    var enChargement = false
    var messageErreur: String? = nil
    var rechercheSansResultat = false

    private let network = NetworkService()

    private func construireRequete(terme: String) throws -> URLRequest {
        var composants = URLComponents(string: "https://images-api.nasa.gov/search")!
        composants.queryItems = [
            URLQueryItem(name: "q", value: terme),
            URLQueryItem(name: "media_type", value: "image")
        ]
        guard let url = composants.url else {
            throw NetworkError.invalidURL
        }
        return URLRequest(url: url)
    }

    func rechercher() async {
        let terme = texteSearch.trimmingCharacters(in: .whitespaces)
        guard !terme.isEmpty else {
            messageErreur = "Tape un terme de recherche."
            resultats = []
            rechercheSansResultat = false
            return
        }

        enChargement = true
        messageErreur = nil
        rechercheSansResultat = false

        do {
            let requete = try construireRequete(terme: terme)
            let reponse = try await network.fetch(requete, as: NASAReponse.self)
            resultats = reponse.collection.items.compactMap { ObjetCeleste(depuisItem: $0) }
            rechercheSansResultat = resultats.isEmpty
        } catch {
            messageErreur = "Impossible de charger les résultats."
        }

        enChargement = false
    }

    func effacer() {
        texteSearch = ""
        resultats = []
        messageErreur = nil
        rechercheSansResultat = false
    }
}
