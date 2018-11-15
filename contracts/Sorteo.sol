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

    mapping (uint => WinnerSerieSelected) registrated;
	
    // function determinateWinners(SignIn signin, uint id_game , string game_name, uint id_sorteo, string sorteo_name, int256[] WinnerSerie, uint ticketNumber, uint amount_to_transfer) public {
    //     signin.register(walletUser) = User;
    //     signin.register(Game.id_game) = id_game;
    //     signin.register(Game.game_name) = game_name;
    //     signin.register(Sorteo.id_sorteo) = id_sorteo;
    //     signin.register(Sorteo.sorteo_name) = sorteo_name;
    //     registrated = 
        
    // }

    function determinateWinners2(uint winners, uint id_game , string game_name, uint id_sorteo, string sorteo_name, int256[] WinnerSerie, uint ticketNumber, uint amount_to_transfer) public {
         registrated[winners].WinnerSerie = WinnerSerie;
         registrated[winners].signin.register(Game.id_game) = id_name;
         registrated[winners].signin.register(Game.game_name) = game_name;
         registrated[winners].signin.register(Sorteo.id_sorteo) = id_sorteo;
         registrated[winners].signin.register(Sorteo.sorteo_name) = sorteo_name;
         registrated[winners].signin.register(ticketNumber) = ticketNumber;
         registrated[winners].created_at = block.timestamp;
         registrated[winners].updated_at = block.timestamp;
         registrated[winners].amount_to_transfer = amount_to_transfer;
         for (var i = 0; i <= registrated.length; i++) {
             registrated[i.amount_to_transfer] = toPay;
             toPay = msg.value;
             registrated[i.walletUser].transfer(msg.value);
         }


        
    }



    // function TransferToWinnner(address walletUser) private payable {
    //     amount_to_transfer = msg.value;
    //     walletUser.transfer(msg.value);
        
    // }

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