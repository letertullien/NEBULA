//
//  NASAModels.swift
//  NEBULA
//
//  Created by Admin on 2026-08-31.
//
 
import Foundation

struct NASAReponse: Codable {
    let collection: NASACollection
}

struct NASACollection: Codable {
    let items: [NASAItem]
}

struct NASAItem: Codable {
    let data: [NASAItemData]
    let links: [NASALink]?
}

struct NASAItemData: Codable {
    let identifiantNasa: String
    let titre: String
    let description: String?
    let centre: String?

    enum CodingKeys: String, CodingKey {
        case identifiantNasa = "nasa_id"
        case titre = "title"
        case description
        case centre = "center"
    }
}

struct NASALink: Codable {
    let href: String
}


extension ObjetCeleste {
    init?(depuisItem item: NASAItem) {
        guard let donnee = item.data.first else { return nil }
        self.id = donnee.identifiantNasa
        self.titre = donnee.titre
        self.description = donnee.description ?? "Aucune description disponible."
        self.centreObservation = donnee.centre ?? "Centre d'observation inconnu"
        self.nomImage = item.links?.first?.href ?? ""
    }
}
