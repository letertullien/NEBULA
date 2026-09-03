# NEBULA

Application iOS développée en SwiftUI pour le projet de fin de session du cours 420-725-AH (Développement d'applications iOS).

## Ce que fait le projet

NEBULA permet d'explorer des objets célestes à travers l'**API NASA Image and Video Library**, et d'y associer ses propres observations personnelles.

- **Entité API** : un objet céleste (`ObjetCeleste`), avec titre, image, description et centre d'observation, téléchargé depuis la NASA.
- **Fiche** : une observation personnelle (`FicheObservation`) créée par l'utilisateur pour un objet céleste précis — notes, météo, lieu et date. Sauvegardée uniquement en local avec Core Data, jamais envoyée sur Internet.

Un objet céleste peut avoir **plusieurs fiches d'observation** (relation *one-to-many*). L'utilisateur peut :
- rechercher des objets célestes via l'API NASA (Vue Recherche),
- consulter uniquement les objets célestes qu'il a déjà observés, avec ses fiches (Vue Mes observations),
- voir le détail complet d'un objet céleste, créer une nouvelle fiche, ou consulter/modifier/supprimer une fiche existante (Vue Détail + Vue additionnelle Fiche).

## Correspondance fichier → rôle

### Vues (dossier `Views`)

| Fichier | Rôle |
|---|---|
| `HomeView.swift` | Vue 0 — page d'accueil de l'application. |
| `SearchView.swift` | Vue 1 — Recherche. Champ de recherche + appel réseau vers l'API NASA, affiche les résultats en liste (image + titre), gère les 3 états (chargement, erreur, succès). |
| `MesObservationsView.swift` | Vue 2 — Contenu personnalisé. Liste des objets célestes ayant au moins une fiche associée (via `@FetchRequest` avec prédicat `lesFiches.@count > 0`), image + titre uniquement (relation one-to-many). |
| `DetailsView.swift` | Vue 3 — Détail unifié. Affiche l'objet céleste (image, titre, description, centre d'observation) reçu soit depuis l'API (recherche), soit depuis Core Data (mes observations). Liste les fiches liées, bouton pour en ajouter une nouvelle, ouvre la vue additionnelle au clic sur une fiche. |
| `FicheExistanteView.swift` | Vue additionnelle — Détail d'une fiche précise (sheet). Affiche notes, météo, lieu, date ; boutons Modifier et Supprimer (avec alerte de confirmation ; supprime uniquement la fiche, pas l'objet céleste). |
| `FicheNewEditView.swift` | Formulaire unique de création **et** modification d'une fiche (le même fichier gère les deux cas via `isEditing`, avec le nom du bouton qui s'adapte). Valide qu'au moins les champs obligatoires (notes, météo) sont remplis avant sauvegarde. |

### Models (dossier `Model`)

| Fichier | Donnée représentée |
|---|---|
| `ModeleObjetCeleste.swift` | `ObjetCeleste` — structure Swift représentant un objet céleste, utilisée aussi bien pour un résultat frais de l'API (via `init?(depuisItem:)`) que pour une entité déjà en Core Data (via `init(depuisEntity:)`). |
| `ModeleFicheObservation.swift` | `FicheObservation` — structure Swift représentant une fiche d'observation, avec un `init(depuisEntity:)` pour la convertir depuis l'entité Core Data `FicheEntity`. |
| `NASAModels.swift` | Structures `Codable` (`NASAReponse`, `NASACollection`, `NASAItem`, `NASAItemData`, `NASALink`) qui décodent directement la réponse JSON de l'API NASA. |

### Réseau (dossier `Service`)

| Fichier | Rôle |
|---|---|
| `NetworkService.swift` | Service générique d'appel réseau (`fetch<T: Decodable>`), utilisé pour interroger l'API NASA et décoder la réponse avec `Codable`. |

### ViewModels (dossier `ViewModel`)

| Fichier | Logique |
|---|---|
| `SearchViewModel.swift` | Logique de la Vue 1 : construit la requête vers l'API NASA, gère l'état de la recherche (chargement, erreur, résultats vides, résultats trouvés). |
| `CrudViewModel.swift` | Logique CRUD sur Core Data : sauvegarde ou retrouve un `ObjetCelesteEntity` (sauvegarde conjointe au moment de la création d'une fiche), sauvegarde une `FicheEntity` (création et modification), et supprime une fiche. |

### Persistance Core Data

| Fichier | Rôle |
|---|---|
| `Persistence.swift` | Configuration du `NSPersistentContainer` pour Core Data, avec fusion automatique des changements. |
| `NEBULAApp.swift` | Point d'entrée de l'app, injecte le `managedObjectContext` dans l'environnement, structure la navigation via `TabView` (Home / Recherche / Mes observations). |

### Modèle Core Data (`NEBULA.xcdatamodeld`)

- **`ObjetCelesteEntity`** (Entité API) — attributs : `id` (String), `titre`, `descriptionTexte`, `nomImage`, `centreObservation`. Relation `lesFiches` (to-many) vers `FicheEntity`.
- **`FicheEntity`** (Fiche) — attributs : `id` (UUID), `notes`, `meteo`, `lieu`, `dateCreation`. Relation `objetCeleste` (to-one) vers `ObjetCelesteEntity`.
- Relation **one-to-many** entre les deux entités : un objet céleste peut avoir plusieurs fiches d'observation.

## Exigences techniques couvertes

- Compilation Xcode 26.3, exécution sur simulateur iPhone 15.
- Persistance locale avec **Core Data** (2 entités + relation one-to-many).
- Navigation exclusivement via `NavigationLink(value:)` + `.navigationDestination(for:)`, un seul `NavigationStack` par pile (à la racine de chaque onglet).
- Appel réseau réel vers l'API NASA, décodé avec `Codable`, avec les 3 états visibles (chargement, erreur, succès).
- Formulaire unique pour créer et modifier une fiche, avec validation des champs obligatoires.
- Suppression d'une fiche avec alerte de confirmation, sans supprimer l'objet céleste associé.
- Bonus : relation one-to-many implémentée avec vue additionnelle dédiée au détail d'une fiche.
