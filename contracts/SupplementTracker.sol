// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SupplementTracker {
    struct SupplementInfo {
        address owner;
        string name;
        string manufacturer;
        uint256 proteins;
        uint256 carbs;
        uint256 fats;
        string expiryDate;
        // string lotNumber;
        // string originOfIngredients;
        // uint256 manufacturingDate;
        // uint256 vitamins;
        // uint256 minerals;
        // string[] testResults;
        // uint256 serialNumber;
        // string transportConditions;
        // string manufacturerAddress;
        // string manufacturerPhone;
        // string manufacturerWebsite;
        // string barcode;
        // string[] regulations;
    }

    struct SupplementSignature {
        address signer;
        bytes32 messageHash;
        bytes signature;
        bool revoked;
    }

    mapping(uint256 => SupplementInfo) public supplements;
    mapping(uint256 => SupplementSignature[]) public supplementsSignatures;
    mapping(uint256 => address[]) authorizedSigners;

    uint256 public supplementsCount = 0;

    function addAuthorizedSigner(uint256 _supplementId, address _signer)
        public
    {
        require(_supplementId < supplementsCount, "Supplement not found.");
        authorizedSigners[_supplementId].push(_signer);
    }

    function removeAuthorizedSigner(uint256 _supplementId, address _signer)
        public
    {
        require(_supplementId < supplementsCount, "Supplement not found.");
        address[] storage data = authorizedSigners[_supplementId];

        for (uint256 i = 0; i < data.length; i++) {
            if (data[i] == _signer) {
                for (uint256 j = i; j < data.length - 1; j++) {
                    data[j] = data[j + 1];
                }
                data.pop();
                break;
            }
        }
    }

    function isRevokeAuthorized(address _signer, uint256 _supplementId)
        internal
        view
        returns (bool)
    {
        bool hasActiveSignature = false;

        SupplementSignature[] memory allSignatures = supplementsSignatures[
            _supplementId
        ];
        uint256 numSignatures = allSignatures.length;

        for (uint256 i = 0; i < numSignatures; i++) {
            if (
                allSignatures[i].signer == _signer && !allSignatures[i].revoked
            ) {
                hasActiveSignature = true;
                break;
            }
        }

        return hasActiveSignature;
    }

    function revokeSignature(uint256 _supplementId) public {
        require(_supplementId < supplementsCount, "Supplement not found.");

        SupplementSignature[] storage signatures = supplementsSignatures[
            _supplementId
        ];

        for (uint256 i = 0; i < signatures.length; i++) {
            if (signatures[i].signer == msg.sender && !signatures[i].revoked) {
                signatures[i].revoked = true;
                break;
            }
        }
    }

    function signSupplement(
        uint256 _supplementId,
        bytes memory _signature,
        bytes32 _messageHash
    ) public {
        require(_supplementId < supplementsCount, "Supplement not found.");
        require(
            isAuthorized(msg.sender, _supplementId),
            "Only authorized parties can sign the supplement."
        );

        SupplementSignature[] storage signatures = supplementsSignatures[
            _supplementId
        ];

        signatures.push(
            SupplementSignature(msg.sender, _messageHash, _signature, false)
        );

        supplementsSignatures[_supplementId] = signatures;
    }

    function isAuthorized(address _signer, uint256 _supplementId)
        internal
        view
        returns (bool)
    {
        require(_supplementId < supplementsCount, "Supplement not found.");

        address[] memory data = authorizedSigners[_supplementId];

        for (uint256 i = 0; i < data.length; i++) {
            if (data[i] == _signer) {
                return true;
            }
        }

        return false;
    }

    function addSupplement(
        string memory _name,
        string memory _manufacturer,
        uint256 _proteins,
        uint256 _carbs,
        uint256 _fats,
        string memory _expiryDate,
        bytes memory _ownerSignature,
        bytes32 _messageHash
    ) public {
        supplements[supplementsCount] = SupplementInfo(
            msg.sender,
            _name,
            _manufacturer,
            _proteins,
            _carbs,
            _fats,
            _expiryDate
        );

        SupplementSignature[] storage signatures = supplementsSignatures[
            supplementsCount
        ];

        signatures.push(
            SupplementSignature(
                msg.sender,
                _messageHash,
                _ownerSignature,
                false
            )
        );

        authorizedSigners[supplementsCount].push(msg.sender);

        supplementsCount++;
    }

    function getSupplements() public view returns (SupplementInfo[] memory) {
        SupplementInfo[] memory supplementList = new SupplementInfo[](
            supplementsCount
        );
        for (uint256 i = 0; i < supplementsCount; i++) {
            supplementList[i] = supplements[i];
        }
        return supplementList;
    }

    function getSupplementSignatures(uint256 _supplementId)
        public
        view
        returns (SupplementSignature[] memory)
    {
        require(_supplementId < supplementsCount, "Supplement not found.");

        SupplementSignature[] memory allSignatures = supplementsSignatures[
            _supplementId
        ];
        uint256 numSignatures = allSignatures.length;

        SupplementSignature[] memory result = new SupplementSignature[](
            numSignatures
        );

        for (uint256 i = 0; i < numSignatures; i++) {
            result[i] = allSignatures[i];
        }

        return result;
    }

    function getAuthorizedSigners(uint256 _supplementId)
        public
        view
        returns (address[] memory)
    {
        require(_supplementId < supplementsCount, "Supplement not found.");

        address[] memory authorizedSignersArray = new address[](
            authorizedSigners[_supplementId].length
        );

        for (uint256 i = 0; i < authorizedSigners[_supplementId].length; i++) {
            authorizedSignersArray[i] = authorizedSigners[_supplementId][i];
        }

        return authorizedSignersArray;
    }
}
