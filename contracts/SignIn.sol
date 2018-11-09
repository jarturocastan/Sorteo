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

    struct Register  {
        address account;
        address walletFundation;
        int256[] numbers;
        string amount_to_foundation;
        uint created_at;
        uint updated_at;
        string total;
        uint id_sorteo;
    }

    mapping(address => Register) registers; 
    
    constructor() public {
		owner = msg.sender;
	}

     
    function register(address walletUser,
    int256[] numbers, address walletFundation, 
    string amount_to_foundation, string total) public payable onlyManagerOrOwner returns(address,address, int256[], string, uint,uint,string,uint) {
        registers[walletUser].account = walletUser;
        registers[walletUser].numbers = numbers;
        registers[walletUser].walletFundation = walletFundation; 
        registers[walletUser].created_at = block.timestamp;   
        registers[walletUser].updated_at = block.timestamp; 
        registers[walletUser].total = total; 
        registers[walletUser].id_sorteo = 1; 
        registers[walletUser].amount_to_foundation = amount_to_foundation; 
        walletFundation.transfer(msg.value);
        emit RegisterEvent(registers[walletUser].account, block.number, blockhash(block.number));
        return (walletUser,walletFundation,numbers,amount_to_foundation,block.timestamp,block.timestamp,total,1);
    }

    
    function setManager(address _manager) public onlyOwner {
        manager = _manager;
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
