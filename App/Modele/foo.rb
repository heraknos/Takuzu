##
# Crée une base de test
#

# Dépendances
require "sqlite3"

# Variables
pathDb = "./test.sqlite" # Chemin de la base de donnée à créer
db = false
rq = false

# Ouverture de la base de données ...
begin
	puts "Ouverture de la base de données ..."
	bdd = SQLite3::Database.new(pathDb)
	rescue SQLite3::Exception => err
		puts "Erreur"
		puts err
		abort
	ensure
		puts "OK"
end

# Création de la table des utilisateurs ...
begin
	puts "Création de la table des utilisateurs ..."
	bdd.execute("
		CREATE TABLE IF NOT EXISTS `utilisateur` (
			`id`								INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			`uuid`								INTEGER UNIQUE,
			`nom`								TEXT NOT NULL,
			`mot_de_passe`						TEXT NOT NULL,
			`date_inscription`					INTEGER NOT NULL,
			`date_derniere_synchronisation`		INTEGER NOT NULL,
			`options`							TEXT NOT NULL,
			`type`								INTEGER NOT NULL
		);
		TRUNCATE TABLE utilisateurs;
	")
	rescue SQLite3::Exception => err
		puts "Erreur"
		puts err
		abort
	ensure
		puts "OK"
end

# Insertion d'utilisateurs ...
begin
	puts "Insertion d'utilisateurs ..."
	bdd.execute("
		INSERT INTO utilisateur VALUES
		(NULL, NULL, 'toto0', 'azerty', 0, 0, 'SERIALISATION', 0),
		(NULL, NULL, 'toto1', 'azerty', 0, 0, 'SERIALISATION', 0),
		(NULL, NULL, 'toto2', 'azerty', 0, 0, 'SERIALISATION', 0);
	")
	rescue SQLite3::Exception => err
		puts "Erreur"
		puts err
		abort
	ensure
		puts "OK"
end

# Création de la table des niveaux ...
begin
	puts "Création de la table des niveaux ..."
	bdd.execute("
		CREATE TABLE IF NOT EXISTS `niveau` (
			`id`								INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			`uuid`								INTEGER UNIQUE,
			`probleme`							TEXT NOT NULL,
			`solution`							TEXT NOT NULL,
			`niveau`							INTEGER NOT NULL,
			`dimention`							INTEGER NOT NULL
		);
		TRUNCATE TABLE utilisateurs;
	")
	rescue SQLite3::Exception => err
		puts "Erreur"
		puts err
		abort
	ensure
		puts "OK"
end

# Insertion de niveaux ...
begin
	puts "Insertion de niveaux ..."
	bdd.execute("
		INSERT INTO niveau VALUES
		(NULL, NULL, '00_________1____0___11_______0_0_1__', '001011010011110100001101110010101100', 1, 6),
		(NULL, NULL, '_1_1___0____0___0__________10__01__10____0___00__10_0__1_________0__1_1_0______0_____1__0______1_____1____0___0__11_0_________0_______1_0_______', '110110100100011001010110100101101001011010011001010101010110101010101010001011001101010100110011101011001100100101100101010010011011101100110010', 2, 12),
		(NULL, NULL, '0___0____1__0_1_0________________1___0_1_1__1__1__0____________1', '0110011011010010001011011010110001010011011010011001011010011001', 6, 8);
	")
	rescue SQLite3::Exception => err
		puts "Erreur"
		puts err
		abort
	ensure
		puts "OK"
end

# Fermeture de la base de données
begin
	puts "Fermeture de la base de données ..."
	bdd.close if bdd
	rescue SQLite3::Exception => e
		puts "Erreur"
		puts e
		abort
	ensure
		puts "OK"
end

# Message fin
puts "La base de test a été créé avec succès"