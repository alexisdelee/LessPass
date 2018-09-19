# Lesspass

Inspiré du concept original [Lesspass](https://lesspass.com).

## Fonctionnement

```bash
bash lesspass.sh <site> <login> <masterpassword> [options]
```

Exemple : générer un mot de passe de 20 caractères uniquement avec des lettres majuscules et des chiffres.  
```bash
bash lesspass.sh https://www.google.fr master 1secret, -An -L=20
```

Les tokens disponibles sont stockés dans le fichier [tokens.sh](tokens.sh).  

### Remarques

Un alias est un ensemble de tokens. Son utilisation reste la même que pour les tokens.  
Il est évidemment possible de mélanger des alias et des tokens.  

L'exemple suivant renvoie le même résultat.  
```bash
# tokens (vcVCns)
bash lesspass.sh https://www.google.fr master 1secret, -vcVCns

# alias (lu) with tokens (ns)
bash lesspass.sh https://www.google.fr master 1secret, -luns
```

### Options

__--algo=\*, --A=\*__  
(par défaut, sha256) choix de l'algorithme de hachage (lister dans le fichier [algorithm.sh](algorithm.sh))  

__--length=\*, --L=\*__  
(par défaut, 16) taille du mot de passe généré  

__--iteration=\*, --I=\*__  
(par défaut, 1) augmente le nombre d'itérations de l'algorithme de hachage. Pratique pour générer un nouveau mot de passe sans changer de crédentiales  

__--clipboard__  
copie le mot de passe généré dans le presse papier au lieu de le générer  

__--store__  
stocke en local des informations utiles (minuscules, majuscules, chiffres, symboles, longueur, itération) pour une utilisation future  

__--host__  
récupère automatiquement les informations précédemment stockées par l'utilisateur  
