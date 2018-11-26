pragma solidity ^0.4.24;
import "./ERC20.sol";

contract StandardCMToken is ERCCM20 {

    uint256 public priceInFinney = 10;
    uint public checker;
    uint public sdate1 = 1543190400; // 26 noviembre 2018
    uint public edate1 = 1544832000; //15 de diciembre 2018
    uint public sdate2 = 1544918400; //16 de diciembre 2018
    uint public edate2 = 1547510400; //15 enero 2019
    uint public sdate3 = 1547596800; //16 enero 2019
    uint public edate3 = 1550188800; //15 frebero 2019
    uint public sdate4 = 1550275200; //16 febrero 2019
    uint public edate4 = 1552608000; //15 marzo 2019
    uint public sdate5 = 1552694400; //16 marzo 2019
    uint public edate5 = 1555286400; //15 abril 2019
    uint256 public total;
    uint256 public totalValue;
    uint256 public extra;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    function setPrice(uint256 newPriceInFinney) public {
        require(newPriceInFinney > 0);
        priceInFinney = newPriceInFinney;
    }


    function transfer(address _to, uint256 _value) public returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        // Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit TransferEvent(msg.sender, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit TransferEvent(_from, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit ApprovalEvent(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    function sellToken(uint256 _amount) public payable {
        if ((checker > sdate1) && (checker < edate1)) {
             if(balances[owner] >= _amount && _amount > 0) {
            total = _amount * priceInFinney;
            totalValue = msg.value * 1000;
            if(total == totalValue) {
                balances[msg.sender] += _amount;
                balances[owner] -= _amount;
            } else {
                revert();
            }
        } else {
            revert();
        }

            
        // } else if((checker > sdate2) && (checker < edate2)) {
        //      if(balances[owner] >= _amount && _amount > 0) {
        //     total = _amount * setPrice(1600000000000000);
            
        //     totalValue = msg.value * 300000000;
        //     if(total == totalValue) {
        //         balances[msg.sender] += _amount;
        //         balances[owner] -= _amount;
        //     } else {
        //         revert();
        //     }
        // } else {
        //     revert();
        // }
            
        // } else if((checker > sdate3) && (checker < edate3)) {
        //     if(balances[owner] >= _amount && _amount > 0) {
        //     total = _amount * setPrice(2400000000000000);
        //     totalValue = msg.value * 300000000;
        //     if(total == totalValue) {
        //         balances[msg.sender] += _amount;
        //         balances[owner] -= _amount;
        //     } else {
        //         revert();
        //     }
        // } else {
        //     revert();
        // }

        // } else if((checker > sdate4) && (checker < edate4)) {
        //     if(balances[owner] >= _amount && _amount > 0) {
        //     total = _amount * setPrice(3500000000000000);
        //     totalValue = msg.value * 300000000;
        //     if(total == totalValue) {
        //         balances[msg.sender] += _amount;
        //         balances[owner] -= _amount;
        //     } else {
        //         revert();
        //     }
        // } else {
        //     revert();
        // }

        // } else if((checker > sdate5) && (checker < edate5)) {
        //     if(balances[owner] >= _amount && _amount > 0) {
        //     total = _amount * setPrice(5300000000000000);
        //     totalValue = msg.value * 300000000;
        //     if(total == totalValue) {
        //         balances[msg.sender] += _amount;
        //         balances[owner] -= _amount;
        //     } else {
        //         revert();
        //     }
        // } else {
        //     revert();
        // }

        // }
    }

   
}

}





