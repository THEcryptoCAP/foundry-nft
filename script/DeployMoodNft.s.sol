//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "lib/oppenzeppelin-contracts/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns(MoodNft){
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
           svgToImageURI(sadSvg);
           svgToImageURI(happySvg);
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        //example:
        //<svg viewBox="0 0 200 200" width="400"  height="400" xmlns="http://www.w3.org/2000/svg".......>
        //data:image/xml+svg;bytes32,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pg0KPHN2ZyB3aWR.....
        string memory baseURL = "data:image/xml+svg;bytes64,";
        string memory svgBase64Encoded = base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}