##
# Classe Utilisateur
#
# Version 4
#
# Voir attribut statistique et option
#
class Utilisateur
	
	### Constantes de classe
	
	OFFLINE = 0
	ONLINE = 1
	
	### Attributs d'instances
	
	attr_accessor :id, :uuid, :nom, :motDePasse, :dateInscription, :dateDerniereSync, :option, :type, :statistique
	
	### Méthodes de classe
	
	##
	# Instancie un utilisateur
	#
    def Utilisateur.creer(*args)
		case args.size
			when 0
				new(nil, nil, nil, nil, Time.now, Time.now, nil, nil, nil)
			when 3
				new(nil, nil, args[0], args[1], Time.now, Time.now, nil, args[2], nil)
			when 9
				new(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
			else
				puts "Utilisateur.creer n'accepte que O, 3 ou 9 arguments"
        end
    end
	
	##
	# Constructeur
	#
	private_class_method :new
    def initialize(id, uuid, nom, motDePasse, dateInscription, dateDerniereSync, option, type, statistique)
		
		# int
		# Identifiant local de l'utilisateur
		@id = id
		
		# int
		# Identifiant universel unique du niveau
		@uuid = uuid
		
		# string
		# Nom de l'utilisateur
		@nom = nom
		
		# string
		# Mot de passe de l'utilisateur
		@motDePasse = motDePasse
		
		# Time
		# Date à laquelle l'utilisateur c'est inscrit
		@dateInscription = dateInscription
		
		# Time
		# Date de la dernière syncronisation entre les données local et le serveur
		@dateDerniereSync = dateDerniereSync
		
		# Option
		# Object option permettant d'accèder aux options de l'utilisateur
		@option = option
		
		# int
		# Type de compte (online/offline)
		@type = type
		
		# Statistique
		# Object statistiques permettant d'accèder aux statistiques de l'utilisateur
		@statistique = statistique
		
    end
	
end
