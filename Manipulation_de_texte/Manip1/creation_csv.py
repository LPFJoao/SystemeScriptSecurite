import csv

data = [
    ["Jean", "25 ans", "Paris"],
    ["Marie", "30 ans", "Lyon"],
    ["Pierre", "22 ans", "Marseille"],
    ["Sophie", "35 ans", "Toulouse"]
]


with open("donnes.csv", "w", newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Prénom", "Âge", "Ville"])
    writer.writerows(data)
    
print("CSV donnes créé avec succès.")
