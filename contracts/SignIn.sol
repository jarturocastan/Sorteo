pragma solidity 0.4.24;

contract SignIn {
    address owner;
    address manager; 
    
    event RegisterEvent(
        address userAccount,
        uint256 block_number,
        bytes32 block_hash
    );

    event UpdateTicketAmountEvent(
        address userAccount,
        uint256 block_number,
        bytes32 block_hash
    );

    struct Game {
        uint id_game;
        string  game_name;
    }

    struct Sorteo {
        int256 id_sorteo;
        string sorteo_name;
    }

    struct Register  {
        address account;
        address walletFundation;
        int256[] numbers;
        string amount_to_foundation;
        uint ticketNumber;
        uint created_at;
        uint updated_at;
        string total;
        Sorteo sorteo;
        Game game;
    }

    mapping(int256 => address[]) indexMapping;
    
    mapping(address => Register) registers; 
    
    constructor() public {
		owner = msg.sender;
        manager = msg.sender;
	}
    
    function register(address walletUser, address walletFundation,int256[] numbers, 
        string total,uint ticketNumber,string amount_to_foundation, int256 id_sorteo, string sorteo_name,uint id_game ,string game_name) 
        public payable onlyManagerOrOwner  {
            indexMapping[id_sorteo].push(walletUser);            
            registers[walletUser].account = walletUser;
            registers[walletUser].numbers = numbers;
            registers[walletUser].walletFundation = walletFundation; 
            registers[walletUser].created_at = block.timestamp;   
            registers[walletUser].updated_at = block.timestamp; 
            registers[walletUser].total = total; 
            registers[walletUser].amount_to_foundation = amount_to_foundation; 
            registers[walletUser].ticketNumber = ticketNumber;
            registers[walletUser].sorteo = Sorteo({id_sorteo : id_sorteo,  sorteo_name : sorteo_name});
            registers[walletUser].game = Game({id_game : id_game,game_name : game_name});
            walletFundation.transfer(msg.value);
            emit RegisterEvent(registers[walletUser].account, block.number, blockhash(block.number));
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }
    
    function getAddressByIdSorteo(int256 id_sorteo) public view returns (address[]) {
        return indexMapping[id_sorteo];
    }
    
    function getGameIdByWalletUser(address walletUser) public view returns (uint) {
        return registers[walletUser].game.id_game;
    }
    
    function getNumberByWalletUser(address walletUser) public view returns (int256[]){
        return  registers[walletUser].numbers;
    }

    function getTicketNumber(address walletUser) public view returns(uint) {
        return  registers[walletUser].ticketNumber;
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