class VueInscription < Vue

    def initialize(modele,titre,controleur,pseudo)
        super(modele,titre,controleur)
        vbox1 = Box.new(:vertical)
        vbox2 = Box.new(:vertical)
        vbox3 = Box.new(:vertical)
        hbox1 = Box.new(:horizontal)
        hbox2 = Box.new(:horizontal)
        hbox3 = Box.new(:horizontal)
		buttonValider = Button.new(:stock_id => Stock::APPLY)
		buttonAnnuler = Button.new(:stock_id => Stock::CANCEL)
        @entryPseudo = Entry.new
        @entryPseudo.text = pseudo
        @entryPassword = Entry.new
        vbox2.pack_start(Label.new("Pseudo",true))
        vbox2.pack_end(Label.new("Mot De Passe",true))
        vbox2.set_homogeneous(true);
        vbox3.pack_start(@entryPseudo)
        vbox3.pack_end(@entryPassword)
        hbox1.add(vbox2)
        hbox1.add(vbox3)
        hbox2.pack_start(buttonValider)
        hbox2.pack_end(buttonAnnuler)
        vbox1.add(hbox1)
        vbox1.add(hbox2)
        @cadre.add(vbox1)


        buttonValider.signal_connect('clicked')    {
            fermerCadre()
            onBtnValiderClicked
        }
        buttonAnnuler.signal_connect('clicked')    {
            fermerCadre()
            onBtnAnnulerClicked
        }
        @entryPseudo.signal_connect('activate')     {
            fermerCadre()
            onBtnValiderClicked
        }
        @entryPassword.signal_connect('activate')   {
            fermerCadre()
            onBtnValiderClicked
        }

        self.actualiser()
    end

	def onBtnValiderClicked
        @controleur.valider(@entryPseudo.text(),@entryPassword.text(),Utilisateur::ONLINE)
	end

	def onBtnAnnulerClicked
        @controleur.annuler()
	end

    def utilisateurExistant(pseudo)

    end

end