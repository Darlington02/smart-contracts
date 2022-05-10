// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    uint256 number;

    // store unsigned integer in the number variable
    function storeNumber(uint256 num) public {
        number = num;
    }

    // retrieve the value of number
    function retrieveNumber() public view returns (uint256){
        return number;
    }
}

//6ab311908f2fee4e87ef206abf36e661da4800a0c7fb46ecda520578d5c8106c
