//
//  ViewController.swift
//  ToDo
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //criar um código para manter os dados e forma segura "dentro da caixa de areia"
    let defaults = UserDefaults.standard
    
    //Definir o que será feito, o que estará na lista
    var itemArray = ["Fazer isso", "Fazer aquilo", "Terminar este"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Para recuperar os dados devemos inserir o codigo a seguir:
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
            
        }
        
        
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
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Para fazer com que o texto adicionado fique na lista, é preciso criar uma nova variável que esteja fora de uma closure
        var textField = UITextField()
        
        
        //mostrar uma janela como um pop up para adicionar novo item
        let alert = UIAlertController (title: "Adicionar Novo To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Adicionar item", style: .default) { (action) in
            
            //o que acontece quando o usuário clica no botão de mais no alerta
            //print("Success!")
            
            self.itemArray.append(textField.text!)
            
            //
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // código que faz aparecer o que foi digitado na lista
            self.tableView.reloadData()
        
        }
        // o codigo serve para colocar um campo de texto no alerta, inserir uma closure é só dar um enter
        alert.addTextField { (alertTextField) in
            //vai mostrar em cinza que irá sumir quando clicar no campo de texto
            alertTextField.placeholder = "Criar novo item"
            //inserir a variável
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        //mostra o alerta
        present (alert, animated: true, completion: nil)
        
        
    }
    

}
