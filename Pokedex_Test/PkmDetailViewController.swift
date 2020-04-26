//
//  PkmDetailViewController.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import UIKit

class PkmDetailViewController: UIViewController {

    @IBOutlet weak var PkmNameLabel: UILabel!
    @IBOutlet weak var PkmImage: UIImageView!
    @IBOutlet weak var Type1Label: UILabel!
    @IBOutlet weak var Type2Label: UILabel!
    @IBOutlet weak var SpeedBar: UIProgressView!
    @IBOutlet weak var SpDefBar: UIProgressView!
    @IBOutlet weak var SpAtkBar: UIProgressView!
    @IBOutlet weak var DefenceBar: UIProgressView!
    @IBOutlet weak var AttackBar: UIProgressView!
    @IBOutlet weak var HPBar: UIProgressView!
    
    
    
    let maxStats:[Int]=[180,230,194,230,190,255]
    var searchTermView=""
    var pokemon:Pokemon?{
        didSet{
            updateView()
        }
    }
    let pokemonController=PokemonController()
    
    override func viewWillAppear(_ animated: Bool) {
        
        //PkmNameLabel.text=searchTermView
        //PkmNameLabel.textAlignment = NSTextAlignment.center
        pokemonController.getPokemon(searchTerm: searchTermView) { (pokemon) in
            guard let searchedPokemon = try? pokemon.get() else{return}
            DispatchQueue.main.async {
                self.pokemon=searchedPokemon
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func updateView(){
        guard isViewLoaded else{return}
        guard let pokemon=pokemon else{return}
        PkmNameLabel.text=pokemon.name.capitalized + "  # \(pokemon.id)"
        PkmNameLabel.textAlignment = NSTextAlignment.center
        guard let pokemonImageData = try? Data(contentsOf: pokemon.sprites.frontDefault) else{return}
        PkmImage.image = UIImage(data: pokemonImageData)
        Type1Label.text=pokemon.types[0].type.name.capitalized
        Type1Label.textAlignment = NSTextAlignment.center
        if(pokemon.types[0].slot==2){
            Type2Label.text=pokemon.types[1].type.name.capitalized
            Type2Label.textAlignment = NSTextAlignment.center
        }else{return}
        SpeedBar.progress=Float(pokemon.stats[0].baseStat)/Float(maxStats[0])
        SpDefBar.progress=Float(pokemon.stats[1].baseStat)/Float(maxStats[1])
        SpAtkBar.progress=Float(pokemon.stats[2].baseStat)/Float(maxStats[2])
        DefenceBar.progress=Float(pokemon.stats[3].baseStat)/Float(maxStats[3])
        AttackBar.progress=Float(pokemon.stats[4].baseStat)/Float(maxStats[4])
        HPBar.progress=Float(pokemon.stats[5].baseStat)/Float(maxStats[5])
        
    }

}
