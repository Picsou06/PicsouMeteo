import json

# Ouvrir le fichier en lecture
with open("city.list.json", "r", encoding="utf-8") as file:
  # Charger le contenu du fichier en tant qu'objet JSON
  data = json.load(file)

# Extraire toutes les valeurs de la clé "name" dans une liste
names = [item["name"] for item in data]

# Créer un nouvel objet JSON contenant uniquement les noms
new_data = {"names": names}

# Ouvrir un fichier en écriture
with open("names.json", "w", encoding="utf-8") as file:
  # Écrire le nouvel objet JSON dans le fichier
  json.dump(new_data, file)
