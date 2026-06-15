# Projet Evalbot — Assembleur 🤖

> **Programmation en assembleur d'un robot Evalbot pour une course dynamique (LEDs, switches, bumpers).**

![Assembleur](https://img.shields.io/badge/Assembleur-14b8a6?style=flat-square)
![Type](https://img.shields.io/badge/ESIEE-555?style=flat-square)
[![Portfolio](https://img.shields.io/badge/Portfolio-afouanee.dev-14b8a6?style=flat-square)](https://afouanee.dev/projects/evalbot-asm)

## ✨ Aperçu
Projet ESIEE de programmation bas niveau : un robot Evalbot est programmé en assembleur pour participer à une course dynamique. Le projet démontre la maîtrise de la programmation directe du matériel — gestion des LEDs, lecture des switches et des bumpers, et pilotage des moteurs — ainsi que la mise en place d'une stratégie de navigation autonome.

## 🚀 Fonctionnalités
- **Allumage** : dès la mise sous tension, les LEDs s'illuminent, prêtes pour l'interaction.
- **Switch 1 (salut)** : les LEDs clignotent, le robot effectue une rotation sur lui-même pour saluer, puis revient à son état initial.
- **Switch 2 (course)** : le robot entre en mode course.
- **Bumpers** : au contact d'un obstacle, la LED du côté touché s'éteint et le robot effectue une légère rotation du côté opposé.
- **Stratégie « suivre le mur »** : le robot longe le mur pour conserver une trajectoire optimale pendant la course.

## 🛠️ Stack technique
- **Langage** : Assembleur
- **Plateforme** : robot Evalbot
- **Outils** : Keil µVision (projet `.uvprojx`), configuration moteur (`RK_Config_Moteur.s`)

## ▶️ Lancer le projet
```text
Ouvrir projet_evalbot.uvprojx dans Keil µVision, compiler,
puis flasher le binaire sur le robot Evalbot.
```

## 📂 Structure
```
main.s                  # programme principal (scénarios LEDs/switches/bumpers/course)
RK_Config_Moteur.s      # configuration des moteurs
projet_evalbot.uvprojx  # projet Keil µVision
Rapport-Projet-G1I10_3I-IN1.pdf  # rapport du projet
```

## 👥 Auteurs du projet
- Afouane MOUHAMAD
- Hamza CHAABA
