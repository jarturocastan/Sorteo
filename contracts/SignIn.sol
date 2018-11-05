pragma solidity 0.4.24;

contract SignIn { 
    struct Register  {
        address account;
        int256 tickets_amount;
        uint created_at;
    }

    mapping(bytes32 => Register) registers; 

    

}

