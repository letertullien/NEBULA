//
//  ObservationViewModel.swift
//  NEBULA
//
//  Created by Admin on 2026-08-31.
//
 
import Foundation
import CoreData

@Observable
class CrudViewModel {
    private let context: NSManagedObjectContext
    var errorMessage: String? = nil

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    private func trouverObjetCelesteEnBase(id: String) -> ObjetCelesteEntity? {
        let requete = ObjetCelesteEntity.fetchRequest()
        requete.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(requete).first
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
            return nil
        }
    }


    func sauvegarderObjetCeleste(_ objetCelesteStruct: ObjetCeleste) -> ObjetCelesteEntity {
        let entiteCeleste = trouverObjetCelesteEnBase(id: objetCelesteStruct.id) ?? ObjetCelesteEntity(context: context)
        entiteCeleste.id = objetCelesteStruct.id
        entiteCeleste.titre = objetCelesteStruct.titre
        entiteCeleste.descriptionTexte = objetCelesteStruct.description
        entiteCeleste.nomImage = objetCelesteStruct.nomImage
        entiteCeleste.centreObservation = objetCelesteStruct.centreObservation

        do {
            try context.save()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }

        return entiteCeleste
    }

    

    private func trouverObservationEnBase(id: UUID) -> FicheEntity? {
        let requete = FicheEntity.fetchRequest()
        requete.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            return try context.fetch(requete).first
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
            return nil
        }
    }


    func sauvegarder(_ ficheStruct: FicheObservation, pour objetCelesteEntity: ObjetCelesteEntity) {
        let entiteObservation = trouverObservationEnBase(id: ficheStruct.id) ?? FicheEntity(context: context)
        entiteObservation.id = ficheStruct.id
        entiteObservation.notes = ficheStruct.notes
        entiteObservation.meteo = ficheStruct.meteo
        entiteObservation.lieu = ficheStruct.lieu
        entiteObservation.dateCreation = ficheStruct.dateCreation
        entiteObservation.objetCeleste = objetCelesteEntity

        do {
            try context.save()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
    }

    func supprimer(_ entiteFiche: FicheEntity) {
        context.delete(entiteFiche)
        do {
            try context.save()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
    }
}
