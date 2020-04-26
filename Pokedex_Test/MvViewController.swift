//
//  MvViewController.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import UIKit

private struct MoveList: Decodable {
    let count:Int
    let results:[Result]

}

private struct Result: Decodable{
    let name:String
}

class MvViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movesTable: UITableView!
    
    var moveList = [String](repeating: "Move", count: 746)
    
    override func viewWillAppear(_ animated: Bool) {
        initList()
        //Hi load the whole Dex on the cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        movesTable.delegate = self
        movesTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    func initList(){
        let requestURL = URL(string: "https://pokeapi.co/api/v2/move/?limit=746")!

        URLSession.shared.dataTask(with: requestURL) { (jsonData, _, error) in
            if let error = error {
                print("Error getting pokemon: \(error)")
                return
            }
            guard let pokemonData = jsonData  else {
                print("Error retrieving data from data task")
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemon = try decoder.decode(MoveList.self, from: pokemonData)
                let moveList = pokemon.results.compactMap( { $0.name })
                print(moveList)
                let moveListCap = moveList.map { $0.capitalized}
                self.moveList=moveListCap
            }
            catch{
                print("Error decoding data to type PokemonList : \(error)")
                print(pokemonData)
            }
        }.resume()
    }
    
    func numberOfSectionsInTableView(in PkmTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return moveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movesCell", for: indexPath)
        cell.textLabel?.text = moveList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        print(moveList[indexPath.row])
        //searchTerm = moveList[indexPath.row]
        //performSegue(withIdentifier: "PokemonDetail", sender: self)
    }
    
    @IBAction func backgroundTap(_ sender: UIControl) {
        searchBar.resignFirstResponder()
    }
    
}
