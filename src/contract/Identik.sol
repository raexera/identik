// Identik.sol
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Identik {

    struct UserProfile {
        string fullName;
        string nationalID;
        string birthPlace;
        string birthDate;
        string gender;
        string religion;
        string maritalStatus;
        string occupation;
        string nationality;
        bool verified;
    }

    mapping(address => UserProfile) private userProfiles;
    mapping(address => string) private uniqueIDAddresses;

    event UserProfileCreated(address indexed user, string uniqueIDAddress);
    event UserProfileUpdated(address indexed user, string uniqueIDAddress);
    event UserVerified(address indexed user);

    modifier userExists() {
        require(bytes(uniqueIDAddresses[msg.sender]).length != 0, "User does not exist.");
        _;
    }

    function generateUniqueIDAddress() internal view returns (string memory) {
        return string(abi.encodePacked(addressToString(msg.sender), "-", block.timestamp));
    }

    function addressToString(address _addr) internal pure returns(string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function createUserProfile(
        string memory _fullName,
        string memory _nationalID,
        string memory _birthPlace,
        string memory _birthDate,
        string memory _gender,
        string memory _religion,
        string memory _maritalStatus,
        string memory _occupation,
        string memory _nationality
    ) public {
        require(bytes(uniqueIDAddresses[msg.sender]).length == 0, "User already exists.");

        uniqueIDAddresses[msg.sender] = generateUniqueIDAddress();

        UserProfile storage profile = userProfiles[msg.sender];
        profile.fullName = _fullName;
        profile.nationalID = _nationalID;
        profile.birthPlace = _birthPlace;
        profile.birthDate = _birthDate;
        profile.gender = _gender;
        profile.religion = _religion;
        profile.maritalStatus = _maritalStatus;
        profile.occupation = _occupation;
        profile.nationality = _nationality;
        profile.verified = false; // Initially unverified

        emit UserProfileCreated(msg.sender, uniqueIDAddresses[msg.sender]);
    }

    function updateUserProfile(
        string memory _fullName,
        string memory _nationalID,
        string memory _birthPlace,
        string memory _birthDate,
        string memory _gender,
        string memory _religion,
        string memory _maritalStatus,
        string memory _occupation,
        string memory _nationality
    ) public userExists {
        UserProfile storage profile = userProfiles[msg.sender];
        profile.fullName = _fullName;
        profile.nationalID = _nationalID;
        profile.birthPlace = _birthPlace;
        profile.birthDate = _birthDate;
        profile.gender = _gender;
        profile.religion = _religion;
        profile.maritalStatus = _maritalStatus;
        profile.occupation = _occupation;
        profile.nationality = _nationality;

        emit UserProfileUpdated(msg.sender, uniqueIDAddresses[msg.sender]);
    }

    function verifyUser() public userExists {
        UserProfile storage profile = userProfiles[msg.sender];
        // In a real-world application, integrate an external verification process here.
        profile.verified = true;
        emit UserVerified(msg.sender);
    }

    function getUserProfile() public view userExists returns (
        string memory fullName,
        string memory nationalID,
        string memory birthPlace,
        string memory birthDate,
        string memory gender,
        string memory religion,
        string memory maritalStatus,
        string memory occupation,
        string memory nationality,
        string memory uniqueIDAddress,
        bool verified
    ) {
        UserProfile storage profile = userProfiles[msg.sender];
        return (
            profile.fullName,
            profile.nationalID,
            profile.birthPlace,
            profile.birthDate,
            profile.gender,
            profile.religion,
            profile.maritalStatus,
            profile.occupation,
            profile.nationality,
            uniqueIDAddresses[msg.sender],
            profile.verified
        );
    }

    // Function to share data with third parties (e.g., companies) with user's consent
    function shareUserProfile(address _thirdParty) public userExists view returns (
        string memory fullName,
        string memory nationalID,
        string memory birthPlace,
        string memory birthDate,
        string memory gender,
        string memory religion,
        string memory maritalStatus,
        string memory occupation,
        string memory nationality,
        string memory uniqueIDAddress,
        bool verified
    ) {
        require(msg.sender == _thirdParty, "Unauthorized access");

        UserProfile storage profile = userProfiles[msg.sender];
        return (
            profile.fullName,
            profile.nationalID,
            profile.birthPlace,
            profile.birthDate,
            profile.gender,
            profile.religion,
            profile.maritalStatus,
            profile.occupation,
            profile.nationality,
            uniqueIDAddresses[msg.sender],
            profile.verified
        );
    }
}
