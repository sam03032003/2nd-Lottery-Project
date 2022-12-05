// SPDX-License-Identfier:GPL-MIT

pragma solidity ^0.8.17;

contract NewLottery
{
    address public manager;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;


    constructor()
    {
        manager = msg.sender;
        lotteryId = 1;
    }

    function getWinnerOfLottery(uint lottery) public view returns(address payable)
    {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns(uint)
    {
        return manager.balance;
    }

    function getPlayers() public view returns(address payable[] memory)
    {
        return players;
    }

    function enter() public payable
    {
        require(msg.value > 0.01 ether);

        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(manager, block.timestamp)));
    }

    function selectWinner() public onlyManager
    {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(manager.balance);

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
    }

    modifier onlyManager()
    {
        require(msg.sender == manager);
        _;
    }
}