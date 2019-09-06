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
    //let defaults = UserDefaults.standard
    
    //Definir o que será feito, o que estará na lista
    var itemArray = [Item]()
    //outra forma de manter os dados sem ser UserDefault
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        
//        let newItem = Item()
//        newItem.title = "Fazer isso"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Fazer aquilo"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Fazer isto"
//        itemArray.append(newItem3)
        
        loadItems()
        
        // Do any additional setup after loading the view.
        // Para recuperar os dados devemos inserir o codigo a seguir:
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//
//        }
        
        
    }
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //o próximo método é o index path com cellforrow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // quando coloca mais arrays, o codigo dá um bug na parte do checkmark, por isso, o melhor jeito de solucionar o problema, é criar um model. 
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        
        //arruma o checkmark
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done  ? .checkmark : .none
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    // A função responsável por fazer sumir quando se clica em qualquer célula na table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //arruma o checkmark, o codigo acima faz a mesma função
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        
        //tableView.reloadData()
        
        //vai imprimir no console o número da row
        //print(indexPath.row)
        
        //o próximo imprime o texto
        //print(itemArray[indexPath.row])
        
        //colocar um chackmark, será no accessory que fica no mainstoryboard
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //sumir com o checkmark
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
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
            let newItem = Item()

            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
        
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            let encoder = PropertyListEncoder()
        
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            }catch{
                print("Error encoding item array, \(error)")
                
                
            }
            self.tableView.reloadData()
            
            self.saveItems()
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
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
            
            
        }
        self.tableView.reloadData()
    }
    func loadItems() {
        if let data = try? Data (contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding item Array, \(error)")
            }
    }
      
}
}
