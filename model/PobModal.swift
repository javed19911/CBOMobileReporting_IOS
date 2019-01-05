//
//  PobModal.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 24/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
class PobModel {
    
    var name = "";
    var id = "";
    var rate = "";
    var noc = "";
    var selected = false;
    var score = "";
    var dr_item = "1";
    var pob = "";
    var selected_Rx = false;
    var highlight = false;
    var  Stock = 0;
    var  Balance = 0;
    
    init( name :String,  id : String,  rate :String) {
        self.name = name;
        self.id = id;
        self.rate = rate;
        selected = false;
        selected_Rx=false;
        score = "";
    }
    
    init(name :String,  id : String,  rate :String, dr_item :String ,Stock : Int,Balance : Int) {
        self.name = name;
        self.id = id;
        self.rate = rate;
        selected = false;
        selected_Rx=false;
        score = "";
        self.dr_item=dr_item;
        self.Stock = Stock;
        self.Balance = Balance;
    }
    
    func getId() -> String{
        return id;
    }
    
    func setId( id :String) {
        self.id = id;
    }
    
    func getName() -> String {
        return name;
    }
    
    func setName( name : String) {
    self.name = name;
    }
    
    func isSelected() -> Bool {
        return selected;
    }
    
    func setSelected( selected : Bool) {
        self.selected = selected;
    }
    
    func setSelected_Rx( selected_Rx : Bool) {
    self.selected_Rx = selected_Rx;
    }
    
   func isSelected_Rx() -> Bool {
    return selected_Rx;
    }
    
    func getScore() -> String {
    return score;
    }
    
    func setScore( score : String) {
    self.score = score;
    }
    
    func getPob() -> String{
    return pob;
    }
    func isHighlighted() ->  Bool {
        return highlight;
    }
    
    func setHighlight( highlight : Bool) {
        self.highlight = highlight;
    }
    
    func isdr_item() -> String{
        return dr_item;
    }
    
    func setdr_item( dr_item : String) {
        self.dr_item = dr_item;
    }
    
    func setPob( pob : String) {
    self.pob = pob;
    }
    
    func getRate() -> String {
    return rate;
    }
    
    func setRate( rate : String) {
    self.rate = rate;
    
    }
    
    func getNOC() -> String{
    return noc;
    }
    
    func setNOC( noc : String) {
        self.noc = noc;
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
