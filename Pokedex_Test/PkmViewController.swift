//
//  PkmViewController.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import UIKit

private struct PokemonList: Decodable {
    let count:Int
    let results:[Result]

}

private struct Result: Decodable{
    let name:String
}


class PkmViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var PkmTable: UITableView!
    
    let pokemonController = PokemonController()
    
    var searchTerm: String?
    
    var pkmList = [String](repeating: "Pokemon", count: 964)
    
    
    override func viewWillAppear(_ animated: Bool) {
        initList()
        //Hi load the whole Dex on the cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        PkmTable.delegate = self
        PkmTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func initList(){
        let requestURL = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=964")!

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
                let pokemon = try decoder.decode(PokemonList.self, from: pokemonData)
                let pkmList = pokemon.results.compactMap( { $0.name })
                print(pkmList)
                let pkmListCap = pkmList.map { $0.capitalized}
                self.pkmList=pkmListCap
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
        return pkmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pkmCell", for: indexPath)
        cell.textLabel?.text = pkmList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        print(pkmList[indexPath.row])
        searchTerm = pkmList[indexPath.row]
        performSegue(withIdentifier: "PokemonDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchTermOut = searchTerm
            else{return}
        let destVC : PkmDetailViewController = segue.destination as! PkmDetailViewController
       destVC.searchTermView = searchTermOut
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text
        performSegue(withIdentifier: "PokemonDetail", sender: self)
    }
    
    
    @IBAction func backgroundTap(_ sender: UIControl) {
        searchBar.resignFirstResponder()
    }
    
}
