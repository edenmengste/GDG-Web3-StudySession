pragma solidity ^0.8.3;

contract week3{
    string[] favmentees;

    function addmentees (string memory name) public {
        favmentees.push(name);
    }

    function addparent(string memory fathersName) {
        favmentees.push(fathersName);
    }

    function getmentee(uint index) public view returns (string memory){
        return favmentees[index];
    }
}


   









}