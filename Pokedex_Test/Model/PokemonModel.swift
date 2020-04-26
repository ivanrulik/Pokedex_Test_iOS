//
//  PokemonModel.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import Foundation
//prueba
struct Pokemon: Decodable {
    let name: String
    let id: Int
    let types:[Type]
    let stats:[Stat]
    let sprites: Sprite
}

struct Stat:Decodable{
    let stat:APIType
    let baseStat:Int
}

struct Type:Decodable{
    let slot:Int
    let type:APIType
}

struct APIType:Decodable{
    let name:String
    let url:String
}

struct Sprite: Decodable {
    let frontDefault: URL
}
