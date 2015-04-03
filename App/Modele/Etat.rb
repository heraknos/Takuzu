class Etat
    @@VIDE = 0
    @@ETAT_1 = 1
    @@ETAT_2 = 2
    @@LOCK_1 = 3
    @@LOCK_2 = 4

    def Etat.vide
        return @@VIDE
    end

    def Etat.etat_1
        return @@ETAT_1
    end

    def Etat.etat_2
        return @@ETAT_2
    end

    def Etat.lock_1
        return @@LOCK_1
    end

    def Etat.lock_2
        return @@LOCK_2
    end

    def Etat.suivant(etat)
        case etat
            when @@VIDE
                return @@ETAT_1
            when @@ETAT_1
                return @@ETAT_2
            when @@ETAT_2
                return @@VIDE
            else
                puts "Etat #{etat} inconnu !"
                return @@VIDE
        end
    end
end