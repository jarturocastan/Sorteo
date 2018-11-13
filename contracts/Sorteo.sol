pragma solidity 0.4.24;

import "./SignIn.sol";

contract Sorteo {
    address owner;
    address manager; 
    SignIn signIn;

    constructor(address address_contract) public {
		owner = msg.sender;
        manager = msg.sender;
         signIn = SignIn(address_contract);
	}

    function determinateWinners(uint id_sorteo, uint id_game, uint ticketNumber, uint amount, int256[] numbers) public {

    }

    function setSignIn(address address_contract) {
        signIn = SignIn(address_contract);
    }
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner() {
        require(owner == msg.sender); _;
    }

    modifier onlyManagerOrOwner() {
        require(owner == msg.sender || manager == msg.sender); _;
    }   
}