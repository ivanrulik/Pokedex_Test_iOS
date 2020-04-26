//
//  PokemonListModel.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/25/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import Foundation

struct PokemonList: Decodable {
    let count:Int
    let results:[Result]

}

struct Result: Decodable{
    let name:String
}
