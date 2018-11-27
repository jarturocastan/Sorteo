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
        int256 id_game;
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
    
    struct WalletTiket {
        uint ticketNumber;
        address walletUser;
    }

    mapping(int256 => address[]) indexMappingAddress;
        mapping(int256 => uint[]) indexMappingTikets;
    mapping(int256 => mapping(int256 => mapping(uint => mapping(address => Register)))) registers;

    
    constructor() public {
		owner = msg.sender;
        manager = msg.sender;
	}
    
    function register(address walletUser, address walletFundation,int256[] numbers, 
        string total,uint ticketNumber,string amount_to_foundation, int256 id_sorteo, string sorteo_name,int256 id_game ,string game_name) 
        public payable onlyManagerOrOwner  {
            indexMappingAddress[id_sorteo].push(walletUser);   
            indexMappingTikets[id_sorteo].push(ticketNumber);
            registers[id_sorteo][id_game][ticketNumber][walletUser].account = walletUser;
            registers[id_sorteo][id_game][ticketNumber][walletUser].numbers = numbers;
            registers[id_sorteo][id_game][ticketNumber][walletUser].walletFundation = walletFundation; 
            registers[id_sorteo][id_game][ticketNumber][walletUser].created_at = block.timestamp;   
            registers[id_sorteo][id_game][ticketNumber][walletUser].updated_at = block.timestamp; 
            registers[id_sorteo][id_game][ticketNumber][walletUser].total = total; 
            registers[id_sorteo][id_game][ticketNumber][walletUser].amount_to_foundation = amount_to_foundation; 
            registers[id_sorteo][id_game][ticketNumber][walletUser].ticketNumber = ticketNumber;
            registers[id_sorteo][id_game][ticketNumber][walletUser].sorteo = Sorteo({id_sorteo : id_sorteo,  sorteo_name : sorteo_name});
            registers[id_sorteo][id_game][ticketNumber][walletUser].game = Game({id_game : id_game,game_name : game_name});
            walletFundation.transfer(msg.value);
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }
    
    function getAddressByIdSorteo(int256 id_sorteo) public view returns (address[]) {
        return indexMappingAddress[id_sorteo];
    }
    
    function getTicketNumberByIdSorteo(int256 id_sorteo) public view returns (uint[]) {
        return indexMappingTikets[id_sorteo];
    }
    
    function getGameIdByWalletUser(address walletUser,int256 id_sorteo, int256 id_game, uint ticketNumber) public view returns (int256) {
        return registers[id_sorteo][id_game][ticketNumber][walletUser].game.id_game;
    }
    
    function getNumberByWalletUser(address walletUser,int256 id_sorteo,int256 id_game,uint ticketNumber) public view returns (int256[]){
        return  registers[id_sorteo][id_game][ticketNumber][walletUser].numbers;
    }
    
    function deleteUserBySorteoAndGame(address walletUser, int256 id_sorteo,int256 id_game, uint ticketNumber) public  {
        delete  registers[id_sorteo][id_game][ticketNumber][walletUser];
    }
    
    
    function deleteIndexMappingAddress(int256 id_sorteo,uint index) {
        delete indexMappingAddress[id_sorteo][index];
    }
    
    function delteIndexMappingTikets(int256 id_sorteo,uint index) {
        delete indexMappingTikets[id_sorteo][index];
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