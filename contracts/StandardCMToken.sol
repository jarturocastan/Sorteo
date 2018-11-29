pragma solidity ^0.4.24;
import "./ERC20.sol";

contract TimeTest {
    
    function currentTime() public view returns (uint) {
        return now;
    }
}

contract StandardCMToken is ERCCM20 {
    
    uint256 public priceInSzabo = 1000;
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
    uint256 public tokensleft1 = 200001500;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
    
// NEW ONES    
    


    /* This generates a public event on the blockchain that will notify clients */
    
//

    function Destroy(uint256 _value) public returns (bool success) {
        require(balances[address(this)] >= _value);   // Check if the sender has enough
        balances[address(this)] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(address(this), _value);
        return true;
    }
        
    function Time_call() public view returns (uint256){
        return now;
    }
    
    
    function transfer(address _to, uint256 _value) public returns (bool success)   {
        
        uint256 checker = now;
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        // Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        //if (balances[address(this)] >= _value && _value > 0) {
        //    balances[address(this)] -= _value;
        //    balances[_to] += _value;
        //    emit TransferEvent(address(this), _to, _value);
        //    return true;
        //} else { 
        //    return false; 
        //}
     if ((checker > sdate1) && (checker < edate1)) {
         if (balances[address(this)] >= _value && _value > 0) {
          //   total = _value * priceInSzabo;
             extra = _value / 2;
            // totalValue = (msg.value / 1000000000000000000) * 1000000;
            if(balances[address(this)] > tokensleft1){
            balances[_to] = balances[_to] + (_value + extra);
            balances[address(this)] = balances[address(this)] - (_value + extra);
                // owner.transfer(msg.value);
            emit TransferEventExtra(address(this), _to, _value, extra);
            return true;
            }else{
                revert();
            }
         } else {
             revert();
         }
     } else if ((checker > sdate2) && (checker < edate2)) {
         if (balances[address(this)] >= _value && _value > 0) {
        //     total = _value * 1600;
             extra = _value * 2 / 5;
            // totalValue = (msg.value / 1000000000000000000) * 1000000;
            if(balances[address(this)] > tokensleft1){
            balances[_to] = balances[_to] + (_value + extra);
            balances[address(this)] = balances[address(this)] - (_value + extra);
                // owner.transfer(msg.value);
            emit TransferEventExtra(address(this), _to, _value, extra);
            return true;
            }else{
                revert();
            }
         } else {
             revert();
         }
     } else if ((checker > sdate3) && (checker < edate3)) {
         if (balances[address(this)] >= _value && _value > 0) {
      //       total = _value * 2400;
        //     totalValue = (msg.value / 1000000000000000000) * 1000000;
            if(balances[address(this)] > tokensleft1){
            extra = _value * 3 / 10;
            balances[_to] = balances[_to] + (_value + extra);
            balances[address(this)] = balances[address(this)] - (_value + extra);
                // owner.transfer(msg.value);
            emit TransferEventExtra(address(this), _to, _value, extra);
            return true;
            }else{
                revert();
            }
         } else {
             revert();
         }
     } else if ((checker > sdate4) && (checker < edate4)) {
         if (balances[address(this)] >= _value && _value > 0) {
    //         total = _value * 3500;
    //         totalValue = (msg.value / 1000000000000000000) * 1000000;
            extra = _value * 1 / 5;
            balances[_to] = balances[_to] + (_value + extra);
            balances[address(this)] = balances[address(this)] - (_value + extra);
                // owner.transfer(msg.value);
            emit TransferEventExtra(address(this), _to, _value, extra);
            return true;
         } else {
             revert();
         }
     } else if ((checker > sdate5) && (checker < edate5)) {
         if (balances[address(this)] >= _value && _value > 0) {
        //     total = _value * 5300; //265
    //         totalValue = (msg.value / 1000000000000000000) * 1000000;
            if(balances[address(this)] > tokensleft1){
             extra = total * 1 / 20;
            balances[_to] = balances[_to] + (_value + extra);
            balances[address(this)] = balances[address(this)] - (_value + extra);
                // owner.transfer(msg.value);
            emit TransferEventExtra(address(this), _to, _value, extra);
            return true;
            } else {
             revert();
         }
         } else {
             revert();
         }
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
    
 
    /*
     * Internal transfer, only can be called by this contract
     */
    
    function transferInCaseOfMoveAll(address _to, uint256 _value) public  returns (bool success) {
        if (balances[address(this)] >= _value && _value > 0) {
            balances[address(this)] -= _value;
            balances[_to] += _value;
            emit TransferEvent(address(this), _to, _value);
            return true;
        } else { 
            return false; 
        }
    }
     
 


    /*
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */



    
  //  function buyToken(uint256 _amount) public payable {
//     uint256 checker = now;
  //   if ((checker > sdate1) && (checker < edate1)) {
    //     if (balances[address(this)] >= _amount && _amount > 0) {
     //        total = _amount * priceInSzabo;
     //        extra = _amount / 2;
     //        totalValue = (msg.value / 1000000000000000000) * 1000000;
     //        if (total == totalValue) {
     //            balances[msg.sender] = balances[msg.sender] + (_amount + extra);
     //            balances[address(this)] = balances[address(this)] - (_amount + extra);
     //            owner.transfer(msg.value);
     //        } else {
     //            revert();
     //        }
     //    } else {
     //        revert();
     //    }
    // } else if ((checker > sdate2) && (checker < edate2)) {
     //    if (balances[address(this)] >= _amount && _amount > 0) {
      //       total = _amount * 1600;
    //         extra = _amount * 2 / 5;
     //        totalValue = (msg.value / 1000000000000000000) * 1000000;
     //        if (total == totalValue) {
      //           balances[msg.sender] = balances[msg.sender] + (_amount + extra);
    //             balances[address(this)] = balances[address(this)] - (_amount + extra);
    //             owner.transfer(msg.value);
     //        } else {
     //            revert();
      //       }
        // } else {
    //         revert();
     //    }
     //} else if ((checker > sdate3) && (checker < edate3)) {
     //    if (balances[address(this)] >= _amount && _amount > 0) {
     //        total = _amount * 2400;
     //        totalValue = (msg.value / 1000000000000000000) * 1000000;
     //        extra = _amount * 3 / 10;
     //        if (total == totalValue) {
     //            balances[msg.sender] = balances[msg.sender] + (_amount + extra);
     //            balances[address(this)] = balances[address(this)] - (_amount + extra);
     //            owner.transfer(msg.value);
     //        } else {
     //            revert();
     //        }
     //    } else {
     //        revert();
     //    }
    // } else if ((checker > sdate4) && (checker < edate4)) {
    //     if (balances[address(this)] >= _amount && _amount > 0) {
    //         total = _amount * 3500;
    //        totalValue = (msg.value / 1000000000000000000) * 1000000;
    //         extra = _amount * 1 / 5;
    //         if (total == totalValue) {
    //             balances[msg.sender] = balances[msg.sender] + (_amount + extra);
     //            balances[address(this)] = balances[address(this)] - (_amount + extra);
     //            owner.transfer(msg.value);
     //        } else {
     //            revert();
     //        }
      //   } else {
    //         revert();
    //     }
    // } else if ((checker > sdate5) && (checker < edate5)) {
    //     if (balances[address(this)] >= _amount && _amount > 0) {
    //         total = _amount * 5300; //265
    //         totalValue = (msg.value / 1000000000000000000) * 1000000;
    //         extra = total * 1 / 20;
    //         if (total == totalValue) {
    //             balances[msg.sender] = balances[msg.sender] + (_amount + extra);
    //             balances[address(this)] = balances[address(this)] - (_amount + extra);
     //            owner.transfer(msg.value);
     //        } else {
     //            revert();
     //        }
      //   } else {
    //         revert();
     //    }
    // }
 //}
 
 
  
}
