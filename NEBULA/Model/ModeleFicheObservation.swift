//
//  ModeleFicheObservation.swift
//  NEBULA
//
//  Created by Admin on 2026-09-01.
//

import Foundation
 

struct FicheObservation: Identifiable, Hashable {
    let id: UUID
    var notes: String
    var meteo: String
    var lieu: String
    var dateCreation: Date
}

extension FicheObservation {
    init(depuisEntity entity: FicheEntity) {
        self.id = entity.id ?? UUID()
        self.notes = entity.notes ?? ""
        self.meteo = entity.meteo ?? ""
        self.lieu = entity.lieu ?? ""
        self.dateCreation = entity.dateCreation ?? Date()
    }
}
