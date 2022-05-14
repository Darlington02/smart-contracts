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

//0x75497109969e76Ede871931b00fBBfE220f0B9b7
