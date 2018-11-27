pragma solidity 0.4.24;

import "./SignIn.sol";

contract Sorteo {
    
    address owner;
    address manager; 
    
    SignIn signIn;
    
    struct Game {
        int256 id_game;
        string  game_name;
    }

    struct SorteoStruct {
        int256 id_sorteo;
        string sorteo_name;
    }

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
        SorteoStruct sorteo;
        Game game;
    } 



    mapping (int256 => WinnerSerieSelected[]) public winners;
    bool  isWinner = false;
    WinnerSerieSelected winner;
    uint count_numbers = 0;
    uint y = 0;
    
    function determinateWinners(int256 id_game , string game_name, int256 id_sorteo, string sorteo_name, int256[] winnerSerie, uint amount_to_transfer) public payable onlyManagerOrOwner{
        
        address[] memory addressInSorteo = signIn.getAddressByIdSorteo(id_sorteo);
        uint[] memory ticketsNumber = signIn.getTicketNumberByIdSorteo(id_sorteo);
        
        if(addressInSorteo.length > 0) {
            for (uint i = 0; i < addressInSorteo.length; i++) {
               if(signIn.getGameIdByWalletUser(addressInSorteo[i],id_sorteo,id_game,ticketsNumber[i]) == id_game) {
                       int256[] memory userNumbers = signIn.getNumberByWalletUser(addressInSorteo[i],id_sorteo,id_game,ticketsNumber[i]);
                        for(uint j = 0; j < winnerSerie.length; j++) {
                            while(y < userNumbers.length) {
                                if(winnerSerie[j] == userNumbers[y]) {
                                    count_numbers++;
                                }
                                y++;
                            }
                            y = 0;
                        }
                       if(count_numbers > 0) {
                            addressInSorteo[i].transfer((amount_to_transfer * count_numbers));
                            winner.sorteo.sorteo_name = sorteo_name;
                            winner.game.game_name = game_name;
                       }
                        signIn.deleteUserBySorteoAndGame(addressInSorteo[i],id_sorteo,id_game,ticketsNumber[i]);
                        signIn.deleteIndexMappingAddress(id_sorteo,i);
                        signIn.delteIndexMappingTikets(id_sorteo,i);
                       count_numbers = 0;
                   
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