// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// we are going to use interfaces
// Interfaces compile down to an ABI => to interact with an already contract
contract FundMe {
    // provides no overflows for iuint256 numbers

    mapping (address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    // construucting our ownership
    // determining that we are the owner of this contract
    constructor() public {
        owner = msg.sender;
    }

    // payable means you can specifcaally add value 
    // while you call the function in the contract
    function fund() public payable {
        uint256  minUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minUSD, "You need to spend more ETH DUDE !");
        addressToAmountFunded[msg.sender] += msg.value;
        // what the ETH -> USD conversion rate
        // this is exactly where oracle blockchain comes to play
        // eth and other same blockchains are deterministic ...
        // Centeralized oracles are a point of failure
        // Chainlink! decenteralized oracle network!
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // because the AggregatorV3Interface is on the goerli testnet 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // we must deploy our contract in the same network to be able to run our code
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // using type casting
        return uint256(answer * 10000000000);
        // 1,397.14676939
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }


    // we can use modifiers to change the behaviours of the function
    modifier onlyOwner{
        // _; first run then check the require!
        require(msg.sender == owner);
        _; // run the remaining code
    }
    function withdraw() payable onlyOwner public {
        // only want the contract owner or admin has the permission
        // require(msg.sender == owner); you can do that way
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    }
}