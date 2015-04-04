##
# La classe GestionnaireNiveau permet d'intéragir avec entitées Niveau
# Utilise le DP Singleton
#
# Version 4
#
class GestionnaireNiveau
	
	### Attributs de classe
	
	@@instance = nil
	
	
	### Attributs d'instances
	
	@stockage = nil
	
	
	### Méthodes de classe
	
	##
	# Renvoi l'instance unique de la classe
	#
	def GestionnaireNiveau.instance
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
	# Crée un object niveau selon un tableau de paramètres
	#
	# ==== Paramètres
	# * +args+ - (tab) Tableau de paramètres (voir classe Niveau)
	#
	# === Retour
	# Renvoi un object niveau hydraté selon les paramètres
	#
	def hydraterNiveau(args)
		return Niveau.creer(
			args[0], # id
			args[1], # uuid
			Grille.creer( args[5] ).charger( args[2] ), # probleme
			Grille.creer( args[5] ).charger( args[3] ), # solution
			args[4], # difficulte
			args[5] # dimention
		)
	end
	private :hydraterNiveau
	
	##
	# Compte le nombre de niveau
	#
	# ==== Retour
	# Renvoi le nombre de niveau
	#
	def recupererNombreNiveau()
		resultat = @stockage.executer("
			SELECT COUNT(id)
			FROM niveau;
		")
		return resultat[0][0];
	end
	
	##
	# Liste les niveaux
	#
	# ==== Paramètres
	# * +o+ - (int) Début de la liste
	# * +l+ - (int) Fin de la liste
	#
	# ==== Retour
	# Renvoi une liste d'objets niveau
	#
	def recupererListeNiveau(o, l)
		resultat = @stockage.executer("
			SELECT *
			FROM niveau
			LIMIT #{ l }
			OFFSET #{ o };
		")
		
		liste = Array.new
		resultat.each do |el|
			liste.push( hydraterNiveau( el ) )
		end
		
		return liste;
	end
	
	##
	# Recherche un niveau selon son id
	#
	# ==== Paramètres
	# * +id+ - (int) Id du niveau
	#
	# ==== Retour
	# Renvoi un objets niveau si se dernier a été trouvé. Nil si non
	#
	def recupererNiveau(id)
		resultat = @stockage.executer("
			SELECT *
			FROM niveau
			WHERE id = #{ id }
			LIMIT 1;
		")
		
		if ( resultat.count == 0 )
			return nil
		end
		
		return hydraterNiveau( resultat[0] )
	end
	
end
