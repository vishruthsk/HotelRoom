////SPDX-License-Indentifier: MIT
pragma solidity ^0.8.0;
 
contract HotelRoom {
    enum status{ // enum is a sorted list with options 
        vacant,
        occupied
    }
    status public currentstatus;
    // event notifies the address of the occupant and the amt he paid 
    event Occupy(address _occupant,uint _value); // event is used when we to notify something 
    address payable owner; // state variables are decalred at the top and local variable inside a func.// payable makes it to recieve funds to that address when ever it wants to 
     constructor (){ // constructor is spl func that runs only once when ever the contract is put on to the blockchain 
         owner=payable(msg.sender); 
         currentstatus=status.vacant; //default status  
     }

     modifier costs(uint _amount){
         require(msg.value >=_amount, "not enough ether provided");
         _;
     }


    function book() public payable costs(2 ether){
        require(currentstatus==status.vacant, " the room is occupied");
        currentstatus=status.occupied;
        (bool sent,bytes memory data) = owner.call{value: msg.value}("");
        require(sent);  
        emit Occupy(msg.sender,msg.value); // notifies

    }

    function checkout() public returns(bool success) {
        currentstatus=status.vacant;
    }
} 