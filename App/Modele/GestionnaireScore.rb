##
# La classe GestionnaireScore permet d'intéragir avec entitées Score
# Utilise le DP Singleton
#
# Version 8
#
class GestionnaireScore
	
	### Attributs de classe
	
	@@instance = nil
	
	
	### Attributs d'instances
	
	@stockage = nil
	
	
	### Méthodes de classe
	
	##
	# Renvoi l'instance unique de la classe
	#
	def GestionnaireScore.instance
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
	# Crée un object score selon un tableau de paramètres
	#
	# ==== Paramètres
	# * +args+ - (tab) Tableau de paramètres (voir classe Score)
	#
	# === Retour
	# Renvoi un object score hydraté selon les paramètres
	#
	def hydraterScore(args)
		return Score.creer(
			args[0], # id
			args[1], # uuid
			args[2], # version
			args[3], # temps_total
			args[4], # nb_coups
			args[5], # nb_conseils
			args[6], # nb_aides
			args[7], # id_utilisateur
			args[8]  # id_niveau
		)
	end
	private :hydraterScore
	
	##
	# Recherche un score selon son id
	#
	# ==== Paramètres
	# * +id+ - (int) Id du score
	#
	# ==== Retour
	# Renvoi un objets score si se dernier a été trouvé. Nil si non
	#
	def recupererScore(id)
		resultat = @stockage.executer("
			SELECT *
			FROM score
			WHERE id = #{ id }
			LIMIT 1;
		")
		
		if ( resultat.count == 0 )
			return nil
		end
		
		return hydraterScore( resultat[0] )
	end
	
	##
	# Compte le nombre de scores
	#
	# ==== Retour
	# Renvoi le nombre de score
	#
	def recupererNombreScore
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM score;
		")
		return resultat[0][0];
	end
	
	##
	# Liste les scores
	#
	# ==== Paramètres
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets scores
	#
	def recupererListeScore(o, l)
	
		resultat = @stockage.executer("
			SELECT *
			FROM score
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterScore( el ) )
		end
		
		return liste;
	end
	
	##
	# Compte le nombre de scores d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut connaitre le nombre de score
	#
	# ==== Retour
	# Renvoi le nombre de score d'un utilisateur
	#
	def recupererNombreScoreUtilisateur(u)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM score
			WHERE id_utilisateur = #{ u.id };
		")
		return resultat[0][0];
	end
	
	##
	# Liste les scores d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut récupérer les scores
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets score d'un utilisateur
	#
	def recupererListeScoreUtilisateur(u, o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM score
			WHERE id_utilisateur = #{ u.id }
			ORDER BY
				temps_total,
				nb_coups DESC,
				nb_conseils DESC,
				nb_aides DESC
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterScore( el ) )
		end
		
		return liste;
	end
	
	##
	# Compte le nombre de scores d'un utilisateur sur un niveau
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut connaitre le nombre de score
	# * +n+ - (Niveau) Niveau dont l'on veut récupérer les scores
	#
	# ==== Retour
	# Renvoi le nombre de score d'un utilisateur sur le niveau
	#
	def recupererNombreScoreUtilisateurNiveau(u, n)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM score
			WHERE
				id_utilisateur = #{ u.id }
				AND id_niveau = #{ n.id };
		")
		return resultat[0][0];
	end
	
	##
	# Liste les scores d'un utilisateur sur un niveau
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont l'on veut récupérer les scores
	# * +n+ - (Niveau) Niveau dont l'on veut récupérer les scores
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets score d'un utilisateur sur le niveau
	#
	def recupererListeScoreUtilisateurNiveau(u, n, o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM score
			WHERE
				id_utilisateur = #{ u.id }
				AND id_niveau = #{ n.id }
			ORDER BY
				temps_total,
				nb_coups DESC,
				nb_conseils DESC,
				nb_aides DESC
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterScore( el ) )
		end
		
		return liste;
	end
	
	##
	# Compte le nombre de scores d'un niveau
	#
	# ==== Paramètres
	# * +n+ - (Niveay) Niveau dont l'on veut connaitre le nombre de score
	#
	# ==== Retour
	# Renvoi le nombre de score d'un niveau
	#
	def recupererNombreScoreNiveau(n)
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM score
			WHERE id_niveau = #{ n.id };
		")
		return resultat[0][0];
	end
	
	##
	# Liste les scores d'un niveau
	#
	# ==== Paramètres
	# * +n+ - (Niveau) Niveau dont l'on veut récupérer les scores
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets score d'un utilisateur
	#
	def recupererListeScoreNiveau(n, o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM score
			WHERE
				id_niveau = #{ n.id }
			ORDER BY
				temps_total,
				nb_coups DESC,
				nb_conseils DESC,
				nb_aides DESC
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterScore( el ) )
		end
		
		return liste;
	end
	
	##
	# Fait persister les données d'un score
	#
	# ==== Paramètres
	# * +s+ - (Score) Score dont il faut faire persister les informations
	#
	def insert(s)
		@stockage.executer("
			INSERT INTO score
			VALUES (
				null,
				#{ ( s.uuid == nil ) ? "null" : s.uuid },
				#{ s.version },
				#{ s.tempsTotal },
				#{ s.nbCoups },
				#{ s.nbConseils },
				#{ s.nbAides },
				#{ s.idUtilisateur },
				#{ s.idNiveau }
			);
		")
		s.id = @stockage.dernierId()
	end
	private :insert
	
	##
	# Fait persister les données d'un score
	#
	# ==== Paramètres
	# * +s+ - (Score) Score dont il faut faire persister les informations
	#
	def update(s)
		@stockage.executer("
			UPDATE score
			SET
				uuid = #{ ( s.uuid == nil ) ? "null" : s.uuid },
				version = version + 1,
				temps_total = #{ s.tempsTotal },
				nb_coups = #{ s.nbCoups },
				nb_conseils = #{ s.nbConseils },
				nb_aides = #{ s.nbAides },
				id_utilisateur = #{ s.idUtilisateur },
				id_niveau = #{ s.idNiveau }
			WHERE id = #{ s.id };
		")
		s.version = s.version + 1
	end
	private :update
	
	##
	# Met à jour un score
	#
	# ==== Paramètres
	# * +s+ - (Score) Score dont il faut mettre à jour les informations
	#
	def sauvegarderScore(s)
		if (s.id == nil)
			insert(s)
		else
			update(s)
		end
	end
	
	##
	# Supprime un score
	#
	# ==== Paramètres
	# * +s+ - (Score) Score à supprimer
	#
	def supprimerScore(s)
		@stockage.executer("
			DELETE FROM score
			WHERE id = #{ s.id };
		")
	end
	
	##
	# Supprimer tous les scores d'un utilisateur
	#
	# ==== Paramètres
	# * +u+ - (Utilisateur) Utilisateur dont il faut supprimer tous les scores
	#
	def supprimerScoreUtilisateur(u)
		@stockage.executer("
			DELETE FROM score
			WHERE id_utilisateur = #{ u.id };
		")
	end
	
	##
	# Change l'utilisateur des scores
	#
	# ==== Paramètres
	# * +u1+ - (Utilisateur) Ancien utilisateur
	# * +u2+ - (Utilisateur) Nouvel utilisateur
	#
	def changerUtilisateurScore( u1, u2 )
		@stockage.executer("
			UPDATE score
			SET
				version = version + 1,
				id_utilisateur = #{ u2.id }
			WHERE id_utilisateur = #{ u1.id };
		")
	end
	
	##
	# Supprime les uuid de toutes les scores d'un utilisateur
	#
	# ==== Paramètres
	# * +utilisateur+ - (Utilisateur) Utilisateur dont l'on veux supprimer les uuid de ses scores
	#
	def supprimerUuidScoreUtilisateur( utilisateur )
		@stockage.executer("
			UPDATE score
			SET
				uuid = null,
				version = version + 1
			WHERE id_utilisateur = #{ utilisateur.id };
		")
	end
	
end
