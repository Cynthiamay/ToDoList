//
//  ViewController.swift
//  ToDo
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //Definir o que será feito, o que estará na lista
    let itemArray = ["Fazer isso", "Fazer aquilo", "Terminar este"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //o próximo método é o index path com cellforrow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    // A função responsável por fazer sumir quando se clica em qualquer célula na table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //vai imprimir no console o número da row
        //print(indexPath.row)
        
        //o próximo imprime o texto
        //print(itemArray[indexPath.row])
        
        //colocar um chackmark, será no accessory que fica no mainstoryboard
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //sumir com o checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        // o código a seguir não vai grifar o texto de cinza quando a opção for selecionada, irá piscar a cor somente como uma animação
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
