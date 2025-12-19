// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract tutorial3{
    struct Mentee {
        string name;
        string id;
        bool isPresent;
        uint age;
    }

Mentee public m;

function setm(string memory _name, string memory _id, bool _isPresent, uint _age)public{
    m = Mentee(_name,_id,_isPresent,_age); 
}

function getm()public view returns(string memory _name, string memory _id, bool _isPresent,uint _age) {
   return (m.name, m.id, m.isPresent, m.age);
}
}