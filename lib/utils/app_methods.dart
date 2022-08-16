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
        EthereumAddress.fromHex(AppStrings.fractionalizeContractAddress);

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

    debugPrint("Result: " + result.toString());
  }

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
        EthereumAddress.fromHex(AppStrings.fractionalizeContractAddress);

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

    debugPrint("Result: " + result.toString());
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
      contractAddress: AppStrings.fractionalizeContractAddress,
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
}
