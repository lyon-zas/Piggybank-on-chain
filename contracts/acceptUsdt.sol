// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract acceptUsdt {
    IERC20 public usdt;
    address public owner;
    event TrasferSent(address _from,address to, uint256 amount);
// address _usdtAddress = 0xD92E713d051C37EbB2561803a3b5FBAbc4962431;
    Deposit[] public deposits;

    struct Deposit{
        uint256 amount;
    }

    constructor (address _usdtAddress) {
        usdt = IERC20(_usdtAddress);
    }

    modifier onlyOwner{
        require(msg.sender == owner, "you are not the owner");
        _;
    }

    // receive() external payable{}
    function _approve(address _spender, uint256 amount) public{
        usdt.approve(_spender,amount);
    }

    function deposit(uint256 amount, address to, address from) external{
        
        usdt.transferFrom(from, to, amount);
        emit TrasferSent(from, to, amount);
    }

    function withdraw(uint256 amount) external onlyOwner{
        usdt.transfer(msg.sender,amount);
    }

    function totalDeposits() public view returns(uint256){
        return address(this).balance;
    }

}

//0x261a88dda92cafc7052EaC9360AF899F98829d8C
// fr 0x4818569AA9dE13d3cC1D702Cd10a95932799a674   963