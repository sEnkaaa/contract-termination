# ContractTermination

## Description

`ContractTermination` est un module Ruby permettant de calculer la **date de résiliation au plus tôt possible** d’un contrat d’assurance selon les règles légales en vigueur, notamment la nouvelle réglementation entrée en vigueur en octobre 2024.  

Ce module est conçu pour être intégré facilement dans n’importe quelle partie d’une application Ruby, sans dépendance à Rails.

---

## Contexte métier

Depuis fin 2024, la loi belge a assoupli les règles de résiliation des contrats d’assurance, notamment en réduisant les préavis obligatoires, permettant ainsi aux assurés de résilier leur contrat plus facilement et rapidement.  

Ce module applique ces règles afin de fournir la date à partir de laquelle la résiliation est effectivement possible.

---

## Contrats pris en charge

- **Contrats IARD** (Incendie, Risques Divers), notamment habitation, voiture, moto.  
- **Exclusion des contrats vie**, qui sont régis par une réglementation différente.

---

## Usage

La méthode principale est :

```ruby
ContractTermination.earliest_termination_date(
  contract_type: :iard,
  contract_initial_effective_start_date: Date.new(2024, 10, 1),
  requested_termination_date: Date.today
)
```

## Arguments

- `contract_type` : **Symbol**  
  Type de contrat. Actuellement, seul le type `:iard` est supporté.

- `contract_initial_effective_start_date` : **Date**  
  Date de prise d’effet initiale du contrat, avant toute éventuelle reconduction.

- `requested_termination_date` : **Date** (optionnel)  
  Date à partir de laquelle on souhaite calculer la date de résiliation la plus proche. Par défaut, c’est la date du jour (`Date.today`).

## Retour
Une instance Date correspondant à la date la plus proche à partir de laquelle la résiliation est possible légalement.

## Règles métiers et sources

### Contexte légal

La résiliation d’un contrat d’assurance en Belgique est encadrée par différentes lois, évoluant dans le temps pour assouplir les conditions pour les assurés.

- **Avant le 1er octobre 2024**  
  La résiliation nécessitait un **préavis de 3 mois avant la date d’anniversaire du contrat**. Si ce délai n'était pas respecté, le contrat était automatiquement renouvelé pour un an.  
  - [Loi du 4 avril 2014 sur les assurances](https://etaamb.openjustice.be/fr/loi-du-04-avril-2014_n2014011239.html)

- **Depuis le 1er octobre 2024**  
  Une réforme permet une résiliation plus souple avec un **préavis réduit à 2 mois**, même pour les contrats reconduits tacitement. Cette mesure vise renforcer les droits des consommateurs.  
  - [Nouvelle règle : résumé par Vanbreda Risk & Benefits](https://www.vanbreda.be/en/insights/new-cancellation-rules-for-insurance-contracts-from-1-october-2024?utm_source=chatgpt.com)  
  - [Ressource officielle – SPF Économie](https://economie.fgov.be/en/themes/financial-services/insurance/insurance-contract/terminating-insurance-contract?utm_source=chatgpt.com)


### Modélisation technique

- Le calcul de résiliation tient compte **des renouvellements annuels** du contrat.
- La **date de prise d’effet** sert de référence pour estimer la prochaine échéance.
- Le module applique dynamiquement la **bonne politique légale** (avant ou après 01/10/2024) selon cette échéance.

## Structure du module

```bash
contract_termination/
├── lib/
│   ├── contract_termination/
│   │   ├── policies/
│   │   │   ├── base_policy.rb           # Classe abstraite commune aux politiques de résiliation
│   │   │   ├── policy_2014_04_04.rb     # Règle en vigueur avant le 1er octobre 2024
│   │   │   └── policy_2024_10_01.rb     # Nouvelle règle à appliquer après le 1er octobre 2024
│   │   ├── contract.rb                  # Représente un contrat avec type et date de prise d'effet
│   │   ├── policy_selector.rb           # Sélectionne la bonne règle en fonction du contexte
│   │   └── termination_request.rb       # Modélise une demande de résiliation
│   └── contract_termination.rb          # Point d’entrée du module avec méthode publique
├── spec/                                # Contient les tests unitaires (RSpec)
│   └── ...                              # Tests pour chaque composant
├── Gemfile                              # Dépendances du projet, incluant RSpec
└── README.md                            # Documentation du module
```

## Tests

Des tests unitaires sont disponibles et peuvent être lancés avec RSpec via la commande :

```bash
rspec
```
