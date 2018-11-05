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
        int256 tickets_amount;
        uint created_at;
        uint updated_at;
    }

    mapping(address => Register) registers; 
     
    function register(address userAccount,int256 ticket_amount) public {
        registers[userAccount].account = userAccount;
        registers[userAccount].tickets_amount = ticket_amount;
        registers[userAccount].created_at = block.timestamp;   
        registers[userAccount].updated_at = block.timestamp; 
        emit RegisterEvent(registers[userAccount].account, block.number, blockhash(block.number));
    }

    function updateTicketAmount(address userAccount,int256 ticket_amount) public {
        registers[userAccount].tickets_amount = ticket_amount;  
        registers[userAccount].updated_at = block.timestamp;
        emit UpdateTicketAmountEvent(registers[userAccount].account, block.number, blockhash(block.number)); 
    }

    modifier onlyOwner() {
        require(owner == msg.sender); _;
    }
    
    modifier onlyManager() {
        require(manager == msg.sender); _;
    }

    modifier onlyManagerOrOwner() {
        require(owner == msg.sender || manager == msg.sender); _;
    }
    
}

