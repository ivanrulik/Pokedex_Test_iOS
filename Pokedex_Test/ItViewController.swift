//
//  ItViewController.swift
//  Pokedex_Test
//
//  Created by Ivan Rulik on 4/24/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import UIKit

private struct ItemList: Decodable {
    let count:Int
    let results:[Result]

}

private struct Result: Decodable{
    let name:String
}

class ItViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var ItemTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemList = [String](repeating: "Item", count: 954)
    
    
    override func viewWillAppear(_ animated: Bool) {
        initList()
        //Hi load the whole Dex on the cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        ItemTable.delegate = self
        ItemTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func initList(){
        let requestURL = URL(string: "https://pokeapi.co/api/v2/item/?limit=954")!

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
                let pokemon = try decoder.decode(ItemList.self, from: pokemonData)
                let itemList = pokemon.results.compactMap( { $0.name })
                print(itemList)
                let itemListCap = itemList.map { $0.capitalized}
                self.itemList=itemListCap
            }
            catch{
                print("Error decoding data to type PokemonList : \(error)")
                print(pokemonData)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        print(itemList[indexPath.row])
        //searchTerm = itemList[indexPath.row]
        //performSegue(withIdentifier: "PokemonDetail", sender: self)
    }
    
    @IBAction func backgroundTap(_ sender: UIControl) {
        searchBar.resignFirstResponder()
    }
    

}
