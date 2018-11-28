pragma solidity ^0.4.24;
import "./ERC20.sol";


library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract StandardCMToken is ERCCM20 {
    
    using SafeMath for uint256;
    uint256 public priceInSzabo = 1000;
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
    uint public mult_dec = 10**18;
    uint256 public add_to;
    uint256 public sub_from;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
    
// NEW ONES    
    
    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);
    
    event Burn(address indexed from, uint256 value);
    
//
    
    

    function setPrice(uint256 newpriceInSzabo) public {
        require(newpriceInSzabo > 0);
        priceInSzabo = newpriceInSzabo;
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
    
   //  function sellTokens(uint256 _amount) public {
    //    balances[msg.sender] = balances[msg.sender].sub(_amount);
      //  uint amountEther = _amount.mul(priceInFinney).div(mult_dec);
    //    msg.sender.transfer(amountEther);
         
//     }


   

    /*
     * Internal transfer, only can be called by this contract
     */
    function transfernew(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balances[_from] >= _value);
        // Check for overflows
        require(balances[_to] + _value > balances[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balances[_from] + balances[_to];
        // Subtract from the sender
        balances[_from] -= _value;
        // Add the same to the recipient
        balances[_to] += _value;
        emit TransferEvent(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balances[_from] + balances[_to] == previousBalances);
    }

 


    /*
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }




 

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal  {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balances[_from] >= _value);               // Check if the sender has enough
        require (balances[_to] + _value >= balances[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balances[_from] -= _value;                         // Subtract from the sender
        balances[_to] += _value;                           // Add the same to the recipient
        emit TransferEvent(_from, _to, _value);
    }

    // @notice Create `mintedAmount` tokens and send it to `target`
    // @param target Address to receive the tokens
    // @param mintedAmount the amount of tokens it will receive
    //function mintToken(address target, uint256 mintedAmount)  public {
    //    balances[target] += mintedAmount;
    //    totalSupply += mintedAmount;
    //    emit TransferEvent(0, this, mintedAmount);
    //    emit TransferEvent(this, target, mintedAmount);
    //}

    // @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
    // @param target Address to be frozen
    // @param freeze either to freeze it or not
    //function freezeAccount(address target, bool freeze)  public {
    //    frozenAccount[target] = freeze;
    //    emit FrozenFunds(target, freeze);
    //}


    // @notice Buy tokens from contract by sending ether
    // function buy() payable public {
    //     uint amount = msg.value / 5/5000;               // calculates the amount
    //     _transfer(this, msg.sender, amount);              // makes the transfers
    // }

    // @notice Sell `amount` tokens to contract
    // @param amount amount of tokens to be sold
    // function sell(uint256 amount) public {
    //     address myAddress = this;
    //     require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
    //     _transfer(msg.sender, this, amount);              // makes the transfers
    //     msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
    // }


    
  //  function buyTokens() public payable{
    //    uint numberofTokens = msg.value.mul(mult_dec).div(priceInFinney);        
      //  require(numberofTokens > 0);
    //    balances[msg.sender] = balances[msg.sender].add(numberofTokens); 
            
//    }

//    function buy() payable public returns (uint _amount){
//        _amount = msg.value / priceInFinney;                    // calculates the amount
//        transfer(msg.sender, _amount);
//        return _amount;
//    }

//    function sell(uint _amount) public returns (uint revenue){
//        require(balances[msg.sender] >= _amount);         // checks if the sender has enough to sell
//        balances[owner] += _amount;                        // adds the amount to owner's balance
//        balances[msg.sender] -= _amount;                  // subtracts the amount from seller's balance
//        revenue = _amount * priceInFinney;
//        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
//        transferFrom(msg.sender, owner, _amount);         // executes an event reflecting on the change
//        return revenue;                                   // ends function and returns
//    }

    function sellToken(uint256 _amount) public payable {
        if ((checker > sdate1) && (checker < edate1)) {
             if(balances[address(this)] >= _amount && _amount > 0) {
            total = _amount * priceInSzabo;
            totalValue = msg.value * 1000000;
            extra = total / 2;
            if(total == totalValue) {
             balances[msg.sender] = balances[msg.sender] + (_amount + extra);
            balances[address(this)] =  balances[address(this)] - (_amount + extra);
            transfer(address(this),add_to);
            owner.transfer(msg.value);
            transferFrom(address(this),owner,msg.value);
                //transferFrom(address(this),msg.sender,add_to);
                //address(this).transfer(msg.value);
            } else {
                revert();
            }
        } else {
            revert();
        }

            
        } else if((checker > sdate2) && (checker < edate2)) {
             if(balances[address(this)] >= _amount && _amount > 0) {
            total = _amount * 1600;
            extra = total * 2/5;
            totalValue = msg.value * 1000000;
            if(total == totalValue) {
                balances[msg.sender] = balances[msg.sender] + (_amount + extra);
            balances[address(this)] =  balances[address(this)] - (_amount + extra);
            //transfer(address(this),add_to);
            owner.transfer(msg.value);
                //transferFrom(address(this),owner,msg.value);
                //transferFrom(address(this),msg.sender,add_to);
                //address(this).transfer(msg.value);
            } else {
                revert();
            }
        } else {
            revert();
        }
            
        } else if((checker > sdate3) && (checker < edate3)) {
            if(balances[address(this)] >= _amount && _amount > 0) {
            total = _amount * 2400;
            totalValue = msg.value * 1000000;
            extra = total * 3/10;
            if(total == totalValue) {
                balances[msg.sender] = balances[msg.sender] + (_amount + extra);
            balances[address(this)] =  balances[address(this)] - (_amount + extra);
            //transfer(address(this),add_to);
            owner.transfer(msg.value);
                //transferFrom(address(this),owner,msg.value);
                //transferFrom(address(this),msg.sender,add_to);
                //address(this).transfer(msg.value);
            } else {
                revert();
            }
        } else {
            revert();
        }

        } else if((checker > sdate4) && (checker < edate4)) {
            if(balances[address(this)] >= _amount && _amount > 0) {
            total = _amount * 3500;
            totalValue = msg.value * 1000000;
            extra = total * 1/5;
            if(total == totalValue) {
               balances[msg.sender] = balances[msg.sender] + (_amount + extra);
            balances[address(this)] =  balances[address(this)] - (_amount + extra);
            //transfer(address(this),add_to);
            owner.transfer(msg.value);
                //transferFrom(address(this),owner,msg.value);
                //transferFrom(address(this),msg.sender,add_to);
                //address(this).transfer(msg.value);
            } else {
                revert();
            }
        } else {
            revert();
        }

        } else if((checker > sdate5) && (checker < edate5)) {
            if(balances[address(this)] >= _amount && _amount > 0) {
            total = _amount * 5300; //265
            totalValue = msg.value * 1000000;
            extra = total * 1/20;
            if(total == totalValue) {
                balances[msg.sender] = balances[msg.sender] + (_amount + extra);
            balances[address(this)] =  balances[address(this)] - (_amount + extra);
            //transfer(address(this),add_to);
            owner.transfer(msg.value);
                //transferFrom(address(this),owner,msg.value);
                //transferFrom(address(this),msg.sender,add_to);
                //address(this).transfer(msg.value);
                
                
            } else {
                revert();
            }
        } else {
            revert();
        }

        }
    }

   
}






