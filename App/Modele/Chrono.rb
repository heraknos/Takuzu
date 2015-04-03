class Chrono
    @debut
    @pause
    @fin
       
    def initialize()
        @debut=Time.now
    end
    
    def start()
        @debut=Time.now
    end
    
    def stop()
        @fin=Time.now-@debut
        return @fin
    end

    def to_s()
        temps = Time.now()-@debut
        minutes = sprintf('%02i', ((temps.to_i % 3600) / 60))
        secondes = sprintf('%02i', (temps.to_i % 60))   
        return "#{minutes}:#{secondes}"
    end
    
    def pause() #a utiliser seulement pour les sauvegardes ou regles, penser a masquer la grille
        @pause=Time.now
    end
    
    def finPause()
        @debut+=(Time.now-@pause)
    end

end