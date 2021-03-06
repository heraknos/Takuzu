##
# La classe GestionnaireSauvegarde permet d'intéragir avec entitées Sauvegarde
# Utilise le DP Singleton
#
# Version 8
#
class GestionnaireSauvegarde
	
	### Attributs de classe
	
	@@instance = nil
	
	
	### Attributs d'instances
	
	@stockage = nil
	
	
	### Méthodes de classe
	
	##
	# Renvoi l'instance unique de la classe
	#
	def GestionnaireSauvegarde.instance
		if(@@instance == nil)
			@@instance = new
		end
		
		return @@instance;
	end
	
	##
	# Constructeur
	#
	private_class_method :new
	def initialize
		@stockage = Stockage.instance()
	end
	
	### Méthodes d'instances
	
	##
	# Crée un object sauvegarde selon un tableau de paramètres
	#
	# ==== Paramètres
	# * +args+ - (tab) Tableau de paramètres (voir classe Sauvegarde)
	#
	# === Retour
	# Renvoi un object sauvegarde hydraté selon les paramètres
	#
	def hydraterSauvegarde(args)
		return Sauvegarde.creer(
			args[0], # id
			args[1], # uuid
			args[2], # version
			args[3], # description
			args[4], # date création
			args[5], # contenu
			args[6], # identifiant utilisateur
			args[7]  # identifiant niveau
		)
	end
	private :hydraterSauvegarde
	
	##
	# Compte le nombre de sauvegardes d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut connaitre le nombre de sauvegardes
	#
	# ==== Retour
	# Renvoi le nombre de sauvegardes d'un utilisateur
	#
	def recupererNombreSauvegardeUtilisateur(u)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM sauvegarde
			WHERE id_utilisateur = #{ u.id };
		")
		return resultat[0][0];
	end

	##
	# Compte le nombre de sauvegardes automatiques d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut connaitre le nombre de sauvegardes automatiques
	#
	# ==== Retour
	# Renvoi le nombre de sauvegardes automatiques d'un utilisateur
	#
	def recupererNombreSauvegardeAutomatiqueUtilisateur(u)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM sauvegarde
			WHERE id_utilisateur = #{ u.id }
			AND description LIKE 'Sauvegarde automatique%';
		")
		return resultat[0][0];
	end
	
	##
	# Liste les sauvegardes d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut récupérer les sauvegardes
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets sauvegarde d'un utilisateur
	#
	def recupererSauvegardeUtilisateur(u, o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM sauvegarde
			WHERE id_utilisateur = #{ u.id }
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterSauvegarde( el ) )
		end
		
		return liste;
	end
	
	##
	# Compte le nombre de sauvegardes d'un utilisateur et d'un dimention de grille donnée
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut connaitre le nombre de sauvegardes
	# * +d+ - (int) Dimention des grilles
	#
	# ==== Retour
	# Renvoi le nombre de sauvegardes
	#
	def recupererNombreSauvegardeUtilisateurDimention(u, d)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM sauvegarde
			INNER JOIN niveau
				ON niveau.id = sauvegarde.niveau
			WHERE
				sauvegarde.id_utilisateur = #{ u.id }
				AND niveau.dimention = #{ d };
		")
		return resultat[0][0];
	end
	
	##
	# Liste les sauvegardes d'un utilisateur selon une dimention de grille
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut récupérer les sauvegardes
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	# * +d+ - (int) Dimention des grilles
	#
	# ==== Retour
	# Renvoi une liste d'objets sauvegarde
	#
	def recupererSauvegardeUtilisateurDimention(u, d, o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM sauvegarde
			INNER JOIN niveau
				ON niveau.id = sauvegarde.id_niveau
			WHERE
				sauvegarde.id_utilisateur = #{ u.id }
				AND niveau.dimention = #{ d }
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterSauvegarde( el ) )
		end
		
		return liste;
	end
	
	##
	# Recherche une sauvegarde selon son id
	#
	# ==== Paramètres
	# * +id+ - (int) Id de la sauvegarde
	#
	# ==== Retour
	# Renvoi un objets sauvegarde si se dernier a été trouvé. Nil si non
	#
	def recupererSauvegarde(id)
		resultat = @stockage.executer("
			SELECT *
			FROM sauvegarde
			WHERE id = #{ id }
			LIMIT 1;
		")
		
		if ( resultat.count == 0 )
			return nil
		end
		
		return hydraterSauvegarde( resultat[0] )
	end
	
	
	# Fait persister les données d'un sauvegarde
	
	# ==== Paramètres
	# * +u+ - (Sauvegarde) Sauvegarde dont il faut faire persister les informations
	
	def insert(s)
		@stockage.executer("
			INSERT INTO sauvegarde
			VALUES (
				null,
				#{ ( s.uuid == nil ) ? "null" : s.uuid },
				#{ s.version },
				'#{ s.description }',
				#{ s.dateCreation },
				'#{ s.contenu }',
				#{ s.idUtilisateur },
				#{ s.idNiveau }
			);
		")
		s.id = @stockage.dernierId()
	end
	private :insert
	
	##
	# Fait persister les données d'une sauvegarde
	#
	# ==== Paramètres
	# * +s+ - (Sauvegarde) Sauvegarde dont il faut faire persister les informations
	
	def update(s)
		@stockage.executer("
			UPDATE sauvegarde
			SET
				uuid = #{ ( s.uuid == nil ) ? "null" : s.uuid },
				version = version + 1,
				description = '#{ s.description }',
				date_creation = #{ s.dateCreation },
				contenu = '#{ s.contenu }',
				id_utilisateur = '#{ s.idUtilisateur }',
				id_niveau = #{ s.idNiveau }
			WHERE id = #{ s.id };
		")
		s.version = s.version + 1
	end
	private :update
	
	##
	# Met à jour une sauvegarde
	#
	# ==== Paramètres
	# * +s+ - (Sauvegarde) Sauvegarde dont il faut mettre à jour les informations
	#
	def sauvegarderSauvegarde(s)
		if (s.id == nil)
			insert(s)
		else
			update(s)
		end
	end
	
	##
	# Supprime une sauvegarde
	#
	# ==== Paramètres
	# * +s+ - (Sauvegarde) sauvegarde à supprimer
	#
	def supprimerSauvegarde(s)
		@stockage.executer("
			DELETE FROM sauvegarde
			WHERE id = #{ s.id };
		")
	end

	##
	# Supprime les sauvegardes du niveau et de l'utilisateur passé en paramètre
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut supprimer les sauvegardes de ce niveau
	# * +idNiveau+ - (int) Id du niveau
	#
	def supprimerSauvegardeUtilisateurNiveau(u,idNiveau)
		@stockage.executer("
			DELETE FROM sauvegarde
			WHERE
				sauvegarde.id_utilisateur = #{ u.id }
				AND sauvegarde.id_niveau = #{ idNiveau };
		")
	end
	
	##
	# Supprimer toutes les sauvegardes d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont il faut supprimer toutes les sauvegardes
	#
	def supprimerSauvegardeUtilisateur(u)
		@stockage.executer("
			DELETE FROM sauvegarde
			WHERE id_utilisateur = #{ u.id };
		")
	end
	
	##
	# Change l'utilisateur des sauvegardes
	#
	# ==== Paramètres
	# * +u1+ - (Utilisateur) Ancien utilisateur
	# * +u2+ - (Utilisateur) Nouvel utilisateur
	#
	def changerUtilisateurSauvegarde( u1, u2 )
		@stockage.executer("
			UPDATE sauvegarde
			SET
				version = version + 1,
				id_utilisateur = #{ u2.id }
			WHERE id_utilisateur = #{ u1.id };
		")
	end
	
	##
	# Supprime les uuid de toutes les sauvegardes d'un utilisateur
	#
	# ==== Paramètres
	# * +utilisateur+ - (Utilisateur) Utilisateur dont l'on veux supprimer les uuid de ses sauvegardes
	#
	def supprimerUuidSauvegardeUtilisateur( utilisateur )
		@stockage.executer("
			UPDATE sauvegarde
			SET
				uuid = null,
				version = version + 1
			WHERE id_utilisateur = #{ utilisateur.id };
		")
	end
	
end
