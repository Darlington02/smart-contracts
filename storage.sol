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

//ad5d8e4f9c3e5c222513af0844078fe452a0fc9079b5bfc23933414e9d4988f8
