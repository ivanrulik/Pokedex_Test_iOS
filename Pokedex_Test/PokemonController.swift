//
//  PokemonController.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import Foundation

class PokemonController{
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    let allPoke: String = "?offset=0&limit=964"
    
    func getPokemon(searchTerm: String, completion: @escaping (Result<Pokemon, Error>) -> Void){
        let requestURL = baseURL.appendingPathComponent(searchTerm.lowercased())
        
        URLSession.shared.dataTask(with: requestURL) { (jsonData, _, error) in
            if let error = error {
                print("Error getting pokemon: \(error)")
                completion(.failure(error))
                return
            }
            guard let pokemonData = jsonData else {
                print("Error retrieving data from data task")
                completion(.failure(NSError()))
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemon = try decoder.decode(Pokemon.self, from: pokemonData)
                print(pokemon)
                completion(.success(pokemon))
            }
            catch{
                print("Error decoding data to type Pokemon : \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
