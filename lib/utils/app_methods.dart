import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class AppMethods {
  static Future<void> openUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  static Future<dynamic> query({
    required Web3Client web3client,
    required String functionName,
    required List<dynamic> args,
    required String contractJson,
    required String contractName,
    required String contractAddress,
  }) async {
    final contract = await loadContract(
      contractJson: contractJson,
      contractName: contractName,
      contractAddress: contractAddress,
    );
    final ethFunction = contract.function(functionName);
    final result = await web3client.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );

    return result;
  }

  static Future<DeployedContract> loadContract({
    required String contractJson,
    required String contractName,
    required String contractAddress,
  }) async {
    String abi = await rootBundle.loadString(contractJson);

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }

  static Future<void> setApproval(
    String contractAddress,
    String walletAddress,
  ) async {
    Client httpClient = Client();
    Web3Client web3client = Web3Client(
      AppStrings.polygonEndpoint,
      httpClient,
    );

    await dotenv.load(fileName: '.env');

    EthereumAddress fracContractAddress =
        EthereumAddress.fromHex("0x57197bdc4ad36dfb4f22849dd5a2b437cd02192a");

    EthereumAddress walletAddr = EthereumAddress.fromHex(walletAddress);

    EthPrivateKey credentials =
        EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);

    DeployedContract contract = await AppMethods.loadContract(
      contractJson: "assets/abi/approve.json",
      contractName: "",
      contractAddress: contractAddress,
    );

    final ethFunction = contract.function("setApprovalForAll");
    final result = await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        from: walletAddr,
        contract: contract,
        function: ethFunction,
        parameters: [fracContractAddress, true],
      ),
      chainId: 80001,
    );

    debugPrint("Approval Result: " + result.toString());
  }

  // static Future<void> transferMainToken(
  //   String address,
  //   BigInt tokenId,
  //   String walletAddress,
  // ) async {
  //   const abi = '''[
  //     {
  //       "inputs": [
  //         {"internalType": "address", "name": "_collection", "type": "address"},
  //         {"internalType": "uint256", "name": "_tokenId", "type": "uint256"}
  //       ],
  //       "name": "transferMainToken",
  //       "outputs": [],
  //       "stateMutability": "nonpayable",
  //       "type": "function"
  //     }
  //   ]''';
  //   // final web3provider = web3.Web3Provider(web3.ethereum!);
  //   // final signer = web3provider.getSigner();

  //   final privateWallet = web3.Wallet(dotenv.env['PRIVATE_KEY']!);
  //   final provider = privateWallet.connect(web3.JsonRpcProvider(AppStrings.polygonEndpoint));

  //   final contract = web3.Contract(
  //     AppStrings.fractionalizeContractAddress,
  //     web3.Interface(abi),
  //     provider,
  //   );

  //   final result = await contract.call("transferMainToken", [address, tokenId]);

  //   print("Transfer result" + result);
  // }

  static Future<void> transferMainToken(
    String address,
    BigInt tokenId,
    String walletAddress,
  ) async {
    Client httpClient = Client();
    Web3Client web3client = Web3Client(
      AppStrings.polygonEndpoint,
      httpClient,
    );

    await dotenv.load(fileName: '.env');

    EthereumAddress nftContractAddress =
        EthereumAddress.fromHex("0x57197bdc4ad36dfb4f22849dd5a2b437cd02192a");

    EthereumAddress walletAddr = EthereumAddress.fromHex(walletAddress);

    EthPrivateKey credentials =
        EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);

    DeployedContract contract = await AppMethods.loadContract(
      contractJson: "assets/abi/fractionalize.json",
      contractName: "FractionalizeNFT",
      contractAddress: address,
    );

    final ethFunction = contract.function("transferMainToken");
    final result = await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        from: walletAddr,
        contract: contract,
        function: ethFunction,
        parameters: [nftContractAddress, tokenId],
      ),
      chainId: 80001,
    );

    debugPrint("Transfer Result: " + result.toString());
  }

  static Future<void> fractionalize(
    String walletAddress,
    BigInt amount,
    String uri,
  ) async {
    Client httpClient = Client();
    Web3Client web3client = Web3Client(
      AppStrings.polygonEndpoint,
      httpClient,
    );

    await dotenv.load(fileName: '.env');

    EthereumAddress ethWalletAddress = EthereumAddress.fromHex(walletAddress);

    EthPrivateKey credentials =
        EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);

    DeployedContract contract = await AppMethods.loadContract(
      contractJson: "assets/abi/fractionalize.json",
      contractName: "FractionalizeNFT",
      contractAddress: "0x57197bdc4ad36dfb4f22849dd5a2b437cd02192a",
    );

    final ethFunction = contract.function("mint");
    final result = await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: [ethWalletAddress, amount, uri],
      ),
      chainId: 80001,
    );

    debugPrint("Result: " + result.toString());
  }

  static String getTokenId(String tokenId) {
    late String newTokenId;
    String removed0x = tokenId.substring(2);
    // print(removed0x);

    for (int i = 0; i < removed0x.length; i++) {
      if (removed0x[i] != "0") {
        newTokenId = removed0x.substring(i);
        break;
      }
      if (i == removed0x.length - 1) {
        newTokenId = "0";
      }
    }

    return newTokenId;
  }

  static Future<void> storeData({
    required String collectionAddress,
    required String tokenId,
    required String nftImage,
    required String nftName,
    required String nftDescription,
    required String amount,
    required String walletAddress,
  }) async {
    String newTokenId = int.parse(tokenId.substring(2), radix: 16).toString();
    await fs.FirebaseFirestore.instance
        .collection("NFTs")
        .doc(walletAddress)
        .collection("RecasaNFTs")
        .doc()
        .set({
      "collectionAddress": collectionAddress,
      "tokenId": newTokenId,
      "status": "Pending",
      "nftImage": nftImage,
      "nftName": nftName,
      "nftDescription": nftDescription,
      "nftAmount": amount,
    });
  }

  static Future<bool> getStatus(String contractAddress, String tokenId) async {
    print("Contract Address: " + contractAddress);
    final querySnapshot = await fs.FirebaseFirestore.instance
        .collection("NFTs")
        .where("tokenId", isEqualTo: tokenId)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print(querySnapshot.docs[0].data());
      if (querySnapshot.docs[0].data()['status'] == "Complete") {
        return true;
      }
      return false;
    } else {
      return false;
    }
    // if (!querySnapshot.docs[0].exists) {
    //   return false;
    // }
    // if (querySnapshot.docs[0].data()['status'] == "Complete") {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  static Future<fs.DocumentSnapshot> getRecasaNFT(
    String nftId,
    String walletAddress,
  ) async {
    fs.DocumentSnapshot doc = await fs.FirebaseFirestore.instance
        .collection("NFTs")
        .doc(walletAddress)
        .collection("RecasaNFTs")
        .doc(nftId)
        .get();

    return doc;
  }

  static Future<void> addForSale(
    fs.DocumentSnapshot doc,
    String price,
    String walletAddress,
  ) async {
    await fs.FirebaseFirestore.instance.collection("ForSale").doc().set({
      "nftName": doc.get("nftName"),
      "nftImage": doc.get("nftImage"),
      "nftDescription": doc.get("nftDescription"),
      "nftAmount": doc.get("nftAmount"),
      "nftPrice": price,
      "nftSeller": walletAddress,
    });
  }
}
