// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PiggyBank{
    // using safemath to avoid ovverflow and underflow of numbers
    using SafeMath for uint256;

    uint256 public tokenIn;
    uint256 public tokenOut;

    uint256 public lockTime;

    address public owner;

    constructor () {
        tokenIn = 0;
        tokenOut = 0;
        lockTime = 0 minutes;
        owner = msg.sender;
    }

    // If the address that is calling a function is not the owner, an error will be thrown
    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner of the smart contract!");
        _;
    }

    // Create an array of deposits
    Deposit[] public deposits;

    struct Deposit {
        uint256 _depositId; // The id of the deposit
        uint256 _amount; // Amount of tokens to be deposited
        address _from; // Who made the deposit
        uint256 _depositTime; // When the deposit was made?
        uint256 _unlockTime; // When the deposit will be unlocked?
        // address _depositorsAddress;
    }

    receive() external payable {}    

    function depositEth(uint256 _amount, uint256 _lockTime) public payable {
        require(msg.value == _amount);
        tokenIn = tokenIn.add(_amount);
        // Get the total of deposits that were made
        uint256 depositId = deposits.length;

        uint256 _newLockTime = _lockTime * 1 minutes;
        lockTime = _newLockTime;
        // Create a new struct for the deposit
        Deposit memory newDeposit = Deposit(depositId, msg.value, msg.sender, block.timestamp, block.timestamp.add(lockTime));
        // Push the new deposit to the array
        deposits.push(newDeposit);
        
    }

    function withdrawEthFromDeposit(uint256 _depositId) public  {
        require(block.timestamp >= deposits[_depositId]._unlockTime, "Unlock time not reached!");
        tokenOut = tokenOut.add(deposits[_depositId]._amount);
        payable(deposits[_depositId]._from).transfer(deposits[_depositId]._amount);
    }

    function getBalanceInWei() public view returns (uint256) {
        return address(this).balance;
    }

    
    // Set the unlock time of deposits to 1 year
    // As we don't have "years" in solidity we will use 12 * 30 days
    function setUnlockTimeToOneYear() public onlyOwner {
        lockTime = 12 * 30 days; 
    }
    // Set custom unlock time in minutes
    function setCustomUnlockTimeInMinutes(uint256 _minutes) public onlyOwner {
    uint256 _newLockTime = _minutes * 1 minutes;
    lockTime = _newLockTime;
    }
    // Set new owner
    function setNewOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
    }
}