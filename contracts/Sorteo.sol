pragma solidity 0.4.24;

import "./SignIn.sol";

contract Sorteo is SignIn{
    address owner;
    address manager; 
    SignIn signIn;

    event WinnerEvent(
        address userAccount,
        uint id_game,
        string  game_name,
        int256 id_sorteo,
        string sorteo_name,
        uint256 block_number,
        bytes32 block_hash
    );
    
    constructor(address address_contract) public {
		owner = msg.sender;
        manager = msg.sender;
        signIn = SignIn(address_contract);
	}

    struct WinnerSerieSelected {
        int256[] winnerSerie;
        uint created_at;
        uint updated_at;
        uint amount_to_transfer;
        address account;
        uint ticketNumber;
        Sorteo sorteo;
        Game game;
    } 
    

    mapping (int256 => WinnerSerieSelected[]) public winners;


    function determinateWinners(uint id_game , string game_name, int256 id_sorteo, string sorteo_name, int256[] winnerSerie, uint ticketNumber, uint amount_to_transfer) public payable{
        
        address[] memory addressInSorteo = signIn.getAddressByIdSorteo(id_sorteo);
        
        for (uint i = 0; i < addressInSorteo.length; i++) {
           if(signIn.getGameIdByWalletUser(addressInSorteo[i]) == id_game) {
               if(signIn.getTicketNumber(addressInSorteo[i]) == ticketNumber) {
                   int256[] memory userNumbers = signIn.getNumberByWalletUser(addressInSorteo[i]);
                   bool  isWinner = true;
                   for(uint j = 0; j < winnerSerie.length; j++) {
                       if(winnerSerie[j] != userNumbers[j]) {
                           isWinner = false;
                       }
                   }
                   
                   if(isWinner == true) {
                        addressInSorteo[i].transfer(amount_to_transfer);
                        emit WinnerEvent(addressInSorteo[i],id_game,game_name,id_sorteo,sorteo_name, block.number, blockhash(block.number));
                   }
               }
           }
        }
          
    }


    function setSignIn(address address_contract) public {
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