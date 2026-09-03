//
//  FicheNewEditView.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//

 
import SwiftUI
import CoreData


struct FicheNewEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: FicheObservation
    @ObservedObject var objetCelesteEntity: ObjetCelesteEntity
    let viewModel: CrudViewModel
    private let isEditing: Bool

    init(fiche: FicheObservation? = nil, objetCelesteEntity: ObjetCelesteEntity, viewModel: CrudViewModel) {
        _draft = State(initialValue: fiche ?? FicheObservation(
            id: UUID(), notes: "", meteo: "", lieu: "", dateCreation: Date()
        ))
        self.objetCelesteEntity = objetCelesteEntity
        self.viewModel = viewModel
        self.isEditing = fiche != nil
    }

    var formulaireValide: Bool {
        !draft.notes.trimmingCharacters(in: .whitespaces).isEmpty &&
        !draft.meteo.trimmingCharacters(in: .whitespaces).isEmpty
        
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(isEditing ? "Modifier l'observation" : "Nouvelle observation")
                    .font(.title2)
                    .bold()

                Text("Ajoute les détails de ton observation")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("Vos Notes *", text: $draft.notes)
                    .textFieldStyle(.roundedBorder)

                TextField("Conditions météo *", text: $draft.meteo)
                    .textFieldStyle(.roundedBorder)

                TextField("Lieu de l'observation (optionnel)", text: $draft.lieu)
                    .textFieldStyle(.roundedBorder)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Modifier" : "Enregistrer") {
                        viewModel.sauvegarder(draft, pour: objetCelesteEntity)
                        dismiss()
                    }
                    .disabled(!formulaireValide)
                }
            }
        }
    }
}
