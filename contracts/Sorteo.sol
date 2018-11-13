pragma solidity 0.4.24;

import "./SignIn.sol";

contract Sorteo {
    address owner;
    address manager; 
    SignIn signIn;


    constructor(address address_contract) public {
		owner = msg.sender;
        manager = msg.sender;
        SignIn signin(address_contract);
	}

    struct WinnerSerieSelected {
        int256[] WinnerSerie;
        uint created_at;
        uint updated_at;
        uint amount_to_transfer;
    } 
	
    function determinateWinners(uint id_game , string game_name, uint id_sorteo, string sorteo_name, int256[] WinnerSerie, uint ticketNumber, uint amount_to_transfer) public {
        SignIn. 
        
    }

    function TransferToWinnner(address walletUser) private payable {
        amount_to_transfer = msg.value;
        walletUser.transfer(msg.value);
        
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