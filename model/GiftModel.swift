//
//  GiftModal.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 17/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
public class GiftModel {
    
    var  name = "";
    var  id = "";
    var  selected = false;
    var  score = "";
    var  rate = "";
    var  sample = "";
    var  Stock = 0;
    var  Balance = 0;
    var  highlight=false;
    
    init( name : String, id : String, rate : String) {
        self.name = name;
        self.id = id;
        self.rate = rate;
        selected = false;
        self.highlight=false;
        score = "";
    }
    init( name : String, id : String, rate : String,Stock : Int,Balance : Int) {
        self.name = name;
        self.id = id;
        self.rate = rate;
        selected = false;
        self.highlight=false;
        score = "";
        self.Stock = Stock;
        self.Balance = Balance;
    }
    
    func  getId() -> String{
    return id;
    }
    
    func  setId( id : String) {
        self.id = id;
    }
    
    func getName() -> String{
        return name;
    }
    
    func setName( name  : String) {
        self.name = name;
    }
    
    func isSelected() -> Bool{
        return selected;
    }
    
    func setSelected( selected : Bool) {
        self.selected = selected;
    }
    
    func isHighlighted() -> Bool {
        return highlight;
    }
    
    func setHighlight( highlight : Bool) {
        self.highlight = highlight;
    }
    
    func getScore() -> String{
        return score;
    }
    
    func setScore( score  : String) {
        self.score = score;
    }
    
    func getRate() -> String{
        return rate;
    }
    
    func setRate( rate : String) {
        self.rate = rate;
    }
    
    func setSample( sample : String) {
        self.sample = sample;
    }
    
    func  getSample() -> String {
        return sample;
    }
    
    func getStock() -> Int{
        return Stock;
    }
    
    func setStock( Stock : Int) {
        self.Stock = Stock;
    }
    
    func setBalance( Balance : Int) {
        self.Balance = Balance;
    }
    
    func  getBalance() -> Int {
        return Balance;
    }
}
