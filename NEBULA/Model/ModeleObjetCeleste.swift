//
//  ModeleObjetCeleste.swift
//  NEBULA
//
//  Created by Admin on 2026-09-01.
//
//
 
import Foundation

enum Destination: Hashable {
case Search
case Liste
}


struct ObjetCeleste: Identifiable, Hashable {
    let id: String
    let titre: String
    let description: String
    let nomImage: String
    let centreObservation: String
}

extension ObjetCeleste {
    init(depuisEntity entity: ObjetCelesteEntity) {
        self.id = entity.id ?? UUID().uuidString
        self.titre = entity.titre ?? "Sans titre"
        self.description = entity.descriptionTexte ?? ""
        self.nomImage = entity.nomImage ?? ""
        self.centreObservation = entity.centreObservation ?? "Centre d'observation inconnu"
    }
}
