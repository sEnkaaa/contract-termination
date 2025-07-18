# 📄 ContractTermination – Module Ruby pour la résiliation d’assurance

## 🧾 Description

`ContractTermination` est un module Ruby qui calcule automatiquement la **première date légale de résiliation** d’un contrat d’assurance, en tenant compte des règles en vigueur, notamment la réforme du **1er octobre 2024**.  

Ce module peut être intégré dans n’importe quelle application Ruby (indépendamment de Rails).

---

## ⚖️ Contexte métier

Depuis le 1er octobre 2024, la législation belge a réduit les délais de préavis nécessaires à la résiliation des contrats d’assurance, offrant aux assurés plus de souplesse.  

Ce module applique ces nouvelles règles de manière fiable et automatisée.

---

## 📦 Contrats pris en charge

- **Contrats IARD** (Incendie, Accidents, Risques Divers)  
  Exemples : habitation, auto, moto, etc.

---

## 🚀 Utilisation

Voici un exemple de code pour lancer le calcul de la date de résiliation la plus proche pour un contrat IARD :

```ruby
require_relative 'contract_termination/lib/contract_termination'
require 'date'

result = ContractTermination.earliest_termination_date(
  contract_type: :iard,
  contract_initial_effective_start_date: Date.new(2023, 11, 1),
  requested_termination_date: Date.today
)

puts "Date de résiliation la plus proche : #{result}"
```

---

## ⚙️ Paramètres d'entrée

| Nom                              | Type    | Description                                                                 |
|----------------------------------|---------|-----------------------------------------------------------------------------|
| `contract_type`                  | Symbol  | Type de contrat (`:iard` uniquement pour l’instant)                        |
| `contract_initial_effective_start_date` | Date | Date de prise d’effet initiale du contrat (hors renouvellements annuels).                                  |
| `requested_termination_date`     | Date    | (Optionnel) Date de demande de résiliation. Par défaut : `Date.today`      |

---

## 🔁 Valeur de retour

Une instance `Date` représentant **la première date légale** à laquelle le contrat peut être résilié.

```ruby
# Exemple
# => #<Date: 2024-11-01 ((2460607j,0s,0n),+0s,2299161j)>
```

---

## 📚 Règles appliquées

### 📘 Cadre légal

#### 📆 **Avant le 1er octobre 2024**
- Les contrats d’assurance non-vie, tacitement reconductibles, étaient soumis à la **règle dite “des 3 mois”**.
- Résiliation possible **uniquement à l’échéance annuelle**, avec un **préavis de 3 mois**.  
  Si ce délai n’était pas respecté, le contrat était reconduit automatiquement pour une nouvelle période d’un an.
- 🔗 [Loi du 4 avril 2014](https://etaamb.openjustice.be/fr/loi-du-04-avril-2014_n2014011239.html)

---

#### 📆 **Depuis le 1er octobre 2024** (réforme applicable)
- La **loi du 9 octobre 2023**, entrée en vigueur le **1er octobre 2024**, introduit un droit de résiliation **plus souple**.
- Pour les **contrats IARD reconduits tacitement** et **ayant plus d’un an d’ancienneté**, le preneur peut **résilier à tout moment**, sans frais, moyennant **un préavis de 2 mois**.
- **⚠️ Si le contrat a moins d’un an**, cette faculté **n’est pas encore ouverte** : on applique alors par **fallback** les règles antérieures (préavis de 3 mois à l’échéance annuelle).
- 🔗 [Loi du 9 octobre 2023](https://etaamb.openjustice.be/fr/loi-du-09-octobre-2023_n2023046177.html)  
- 🔗 [Résumé Vanbreda](https://www.vanbreda.be/en/insights/new-cancellation-rules-for-insurance-contracts-from-1-october-2024)  
- 🔗 [SPF Économie – Résiliation](https://economie.fgov.be/en/themes/financial-services/insurance/insurance-contract/terminating-insurance-contract)

---

#### ⚖️ En résumé
| Situation du contrat                           | Loi applicable         | Préavis         | Conditions requises                      |
|------------------------------------------------|------------------------|------------------|------------------------------------------|
| Conclu avant la réforme                        | Loi de 2014            | 3 mois           | Résiliation uniquement à l’échéance      |
| Conclu après réforme, **< 1 an**               | Loi de 2014 *(fallback)* | 3 mois        | Idem, réforme non encore applicable      |
| Conclu après réforme, **>= 1 an**               | Loi de 2023            | 2 mois           | Résiliation libre, même hors échéance    |

---

## 🗂️ Structure du projet

```bash
contract_termination/                         # Racine du projet (nom du module)
├── lib/                                      # Code source Ruby du module
│   ├── contract_termination/                 # Namespace principal du domaine de résiliation
│   │   ├── iard/                             # Bounded context : IARD (Incendie, Accidents, Risques Divers)
│   │   │   ├── policies/                     # Sous-dossier métier : règles légales applicables
│   │   │   │   ├── base_policy.rb            # Classe abstraite commune aux politiques de résiliation
│   │   │   │   ├── policy_2014_04_04.rb      # Règle en vigueur avant le 1er octobre 2024
│   │   │   │   └── policy_2024_10_01.rb      # Nouvelle règle à appliquer après le 1er octobre 2024
│   │   │   ├── contract.rb                   # Représente un contrat avec type et date de prise d'effet
│   │   │   ├── policy_selector.rb            # Sélectionne la bonne règle en fonction du contexte
│   │   │   └── termination_request.rb        # Modélise une demande de résiliation
│   └── contract_termination.rb               # Point d’entrée du module avec méthode publique
├── spec/                                     # Contient les tests unitaires (RSpec)
│   └── ...                                   # Tests pour chaque composant
├── Gemfile                                   # Dépendances du projet, incluant RSpec
└── README.md                                 # Documentation du module
```

---

## 🧪 Tests

Des tests unitaires sont disponibles et peuvent être lancés avec RSpec via les commandes :

```bash
bundle install
rspec
```

---

## 🧩 Évolutivité

Ce module a été conçu pour être facilement extensible grâce à une architecture modulaire.

### 💡 Évolutions possibles

- Prise en charge de **nouveaux types de contrats** (`:health_insurance`, `:legal_protection`, etc.)
- Intégration de **nouvelles règles légales** via de simples ajouts de classes

---

## ✅ Bonnes pratiques appliquées

- Respect des principes Domain-Driven Design (DDD) : séparation claire des responsabilités, modélisation du domaine et isolation des règles métier dans des bounded contexts
- Encapsulation métier via des objets comme `Contract` et `TerminationRequest`
- Sélection dynamique de logique métier avec `PolicySelector`
- Code prêt à être testé, surveillé et versionné proprement

---

Le module est donc prêt à évoluer au rythme des besoins métier ou réglementaires, sans impact majeur sur l'existant.