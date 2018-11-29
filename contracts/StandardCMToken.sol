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

contract TimeTest {
    
    function currentTime() public view returns (uint) {
        return now;
    }
}

contract StandardCMToken is ERCCM20 {
    
    using SafeMath for uint256;
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

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
    
// NEW ONES    

     
        function transfer(address _to, uint256 _value) public  returns (bool success) {
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

    function balanceOf(address _owner)  public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public  returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit ApprovalEvent(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function sellToken(uint256 _amount) public payable {
        TimeTest time = new TimeTest();
        uint checker = time.currentTime();
         if ((checker > sdate1) && (checker < edate1)) {
            if(balances[address(this)] >= _amount && _amount > 0) {
                total = _amount * priceInSzabo;
                extra = _amount / 2;
                totalValue = msg.value * 1000000;
                if(total == totalValue) {
                    balances[msg.sender] = balances[msg.sender] + (_amount + extra);
                    balances[address(this)] =  balances[address(this)] - (_amount + extra);
                    owner.transfer(msg.value);
                    //transfer(address(this),add_to);
                    //transferFrom(address(this),owner,msg.value);
                    //transferFrom(address(this),msg.sender,add_to);
                    //address(this).transfer(msg.value);
                } else {
                    revert();
            }
        } else {
            revert();
        }

            
        }else{
         revert();
     }
        
        
        
     }
   
}