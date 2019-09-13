 //
//  Category.swift
//  ToDoList
//
//  Created by Treinamento on 9/11/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import Foundation
import RealmSwift
 
class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = "" 
    
    let items = List<Item>()   //Array<Int>
    
 }
