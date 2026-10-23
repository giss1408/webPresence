---
title: Sécuriser les paiements Mobile Money dans votre application
description: Faux SMS de confirmation, paiements comptés deux fois, clés d'API exposées : les 8 règles pour sécuriser les paiements Orange Money, Wave et MTN MoMo dans une application mobile ou un SaaS.
ogDescription: Les 8 règles pour que chaque paiement Mobile Money soit vérifié, unique et traçable.
excerpt: Faux SMS de confirmation, paiements comptés deux fois, clés d'API exposées : les 8 règles pour que chaque paiement soit vérifié, unique et traçable.
date: 2026-10-02
readingMinutes: 8
whatsappText: Bonjour, j'aimerais sécuriser les paiements Mobile Money de mon application.
---

Un client montre un SMS « Paiement reçu »… qui n'a jamais été envoyé par l'opérateur. Un paiement est compté deux fois après une coupure réseau. Une clé d'API retrouvée dans l'application permet de déclencher des transactions. Ces incidents sont évitables : voici les règles que nous appliquons sur chaque projet.

## 1. Le serveur décide, jamais le téléphone

Une application mobile peut être modifiée, et un message peut être falsifié. La seule source de vérité est la confirmation que **votre serveur** reçoit de l'opérateur ou de l'agrégateur, puis vérifie. Tant que le serveur n'a pas validé, la commande reste « en attente » : on ne livre pas, on ne débloque pas l'abonnement.

C'est aussi la parade aux **faux SMS de confirmation** et aux captures d'écran truquées : vos vendeurs vérifient le statut dans l'application, alimentée par le serveur, et jamais un message montré par le client.

## 2. Vérifier chaque notification de paiement

Quand l'opérateur prévient votre serveur qu'un paiement a abouti (le « webhook »), le serveur doit s'assurer que le message est authentique :

- vérifier la **signature** du message avec la clé secrète fournie par le prestataire ;
- ou, à défaut, **interroger l'API** du prestataire pour confirmer le statut de la transaction ;
- contrôler que le **montant et la devise** correspondent exactement à la commande.

Sans ces contrôles, n'importe qui connaissant l'adresse de votre serveur pourrait y envoyer un faux « paiement réussi ».

## 3. Les clés secrètes restent sur le serveur

Les clés d'API du prestataire de paiement ne doivent **jamais** se trouver dans l'application mobile : une application publiée peut être décompilée et ses clés extraites. L'application parle à votre serveur ; seul le serveur parle au prestataire. Les clés sont stockées dans un coffre de secrets, pas dans le code source, et renouvelées si un doute existe.

## 4. Un paiement ne compte qu'une fois

Coupures réseau, notifications reçues deux fois, bouton touché deux fois : chaque transaction porte un **identifiant unique**, et le serveur ignore tout traitement en double. Une commande ne peut passer à « payée » qu'une seule fois, même si la confirmation arrive plusieurs fois. C'est le même principe que pour les [applications hors-ligne](/blog/application-mobile-hors-ligne/).

## 5. Le montant est fixé par le serveur

L'application n'envoie jamais le prix à payer : elle envoie le panier ou la formule choisie, et le serveur calcule le montant à partir de ses propres tarifs. Sinon, une application modifiée pourrait payer 100 FCFA un abonnement à 25 000 FCFA.

## 6. Le code secret du client reste chez l'opérateur

Votre application ne demande et ne stocke jamais le code PIN Mobile Money du client. La validation se fait sur l'interface de l'opérateur (menu USSD, application de l'opérateur ou page de paiement). C'est une protection pour vos clients et pour votre responsabilité.

## 7. Tout tracer, tout rapprocher

- **Journal des transactions :** chaque changement de statut est enregistré avec la date, l'origine et l'identifiant du prestataire.
- **Rapprochement régulier :** comparez vos transactions avec le relevé du prestataire, pour repérer un paiement non reçu ou un écart.
- **Alertes :** pics de paiements échoués, montants inhabituels, nombreuses tentatives depuis un même compte.
- **Droits limités :** seuls quelques profils peuvent rembourser ou corriger une transaction, et chacune de leurs actions est journalisée.

## 8. Protéger les données des clients

Numéros de téléphone, historiques d'achat et noms sont des données personnelles. Elles circulent uniquement en connexion chiffrée (HTTPS), sont stockées de façon sécurisée et ne sont conservées que le temps nécessaire. Les lois de protection des données personnelles s'appliquent dans la plupart des pays de la région — par exemple sous le contrôle de la CDP au Sénégal ou de l'ARTCI en Côte d'Ivoire — et nous appliquons aussi le RGPD européen.

## La checklist à garder

<ul class="checks">
  <li>Le statut « payé » est fixé uniquement par le serveur</li>
  <li>Chaque notification de paiement est vérifiée (signature ou API)</li>
  <li>Aucune clé secrète dans l'application mobile</li>
  <li>Chaque paiement a un identifiant unique, sans doublon possible</li>
  <li>Le montant est calculé côté serveur</li>
  <li>Le code PIN n'est jamais saisi dans votre application</li>
  <li>Journal, rapprochement et alertes en place</li>
  <li>Données personnelles chiffrées et protégées</li>
</ul>

Ces règles sont intégrées par défaut dans les applications que nous livrons, y compris notre [MVP SaaS mobile à partir de 250 000 FCFA](/developpement-saas-mobile/). Pour la mise en place pas à pas, lisez aussi [comment intégrer Orange Money, Wave et MTN MoMo](/blog/integrer-mobile-money-application/).
