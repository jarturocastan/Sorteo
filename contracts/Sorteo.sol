pragma solidity 0.4.24;

import "./SignIn.sol";

contract Sorteo {
    struct Ticket {
        address account;
        int256 ticket_number;
        uint created_at;
        uint updated_at;
    }

    mapping(address => Ticket) tikets;

    function agregarTicket() public {

    }


}