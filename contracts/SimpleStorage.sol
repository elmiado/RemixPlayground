// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract SimpleStorage {
    
    uint256 favoriteNumber = 5;
    // bool favoriteBool = false;
    // string favoriteString = 'String';
    // int favoriteInt = -5;
    // address favoriteAdderss = 0x900c8dce3c2Ce466b7eDCc5B6b8a8759d54b48fF;
    // bytes32 favoriteBytes = "cat";

    // This will initials as 0
    // The public keyword defines the visiblity of a variable or a function
    // there differtnt type of type of visibilty in solidity: 
    // external, public, internal and
    // public which we will discuss about them later.
    // default value is internal
    uint256 secondFavoriteNumber;

    // First Sample Function
    // Thorugh a transaction the variable is going to be set
    // by user, every time that somebody call this he pays a little of gas
    // ONLY transact functions paid gas
    function store(uint256 _favoriteNumber) public {
        secondFavoriteNumber = _favoriteNumber;
    }

    // this function is for showing (get func) the variable we store,
    // view functions like this one below becasue of not changing any state
    // dosent pay any gas fees
    function get() public view returns(uint256) {
        return secondFavoriteNumber;
    }

    // this function below called pure function is just returning variables
    // and doing math without changing anything in the smart contract!
    // so they also dont pay anything.
    function getDobule(uint256 anyNumber) public view returns(uint256){
        return anyNumber + secondFavoriteNumber;
    } 

    // this is type of People its like an object and we can create different instance
    // from this
    struct People {
        uint256 peopleFavoriteNumber;
        string name;
    }

    People public miaad = People({peopleFavoriteNumber: 85, name: "miaad"});

    // This is arry type List that we can put different vars into it
    // People[312] is a fixed size array
    People[] public people;

    // we have another type of data called mapping
    // it is some how similar to dict so we can for example sign a number to aperson
    mapping(string => uint256) public nameToFavoriteNumber;

    // memory is going to memory the other option is storage
    // in memory option the data will going to remove after execution! 
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({name: _name, peopleFavoriteNumber: _favoriteNumber}));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}