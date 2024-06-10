# Projet Evalbot Assembleur

Ce projet consiste en la programmation d'un robot Evalbot pour une course dynamique. Lors de son allumage, les LED s'illuminent, et diverses actions sont déclenchées par l'utilisateur via les switches.

## Scénarios

1. **Allumage du robot et illumination des LED**
   - Dès l'allumage, les LED s'illuminent, prêtes pour l'interaction.

2. **Appui sur le switch 1**
   - Lorsque le switch 1 est pressé, les LED clignotent pour préparer le robot à la course.
   - Le robot effectue une rotation sur lui-même pour saluer les fans.
   - Ensuite, il revient à son état initial.

3. **Appui sur le switch 2**
   - Lorsque le switch 2 est pressé, le robot entre en mode course.

4. **Contact d'un bumper**
   - Si l'un des bumpers détecte un contact avec un obstacle, la LED du côté touché s'éteint.

5. **Réaction au contact du bumper**
   - Le robot effectue une légère rotation du côté opposé du bumper actif.

6. **Stratégie adoptée : "Suivre le mur"**
   - Pour maximiser l'efficacité, le robot suit la stratégie de "suivre le mur" pendant la course.
   - Cette stratégie permet au robot de rester en contact avec le mur, assurant ainsi une trajectoire optimale.

## Langage de programmation
Ce projet est développé en assembleur.

## Auteurs
- Afouane MOUHAMAD
- Hamza CHAABA