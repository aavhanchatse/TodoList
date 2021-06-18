import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel with ChangeNotifier {
  List<Task> todo = [];
  int? taskCount;

  bool loading = true;

  final String _rpcUrl = 'http://192.168.29.84:7545';
  final String _wsUrl = 'ws://192.168.29.84:7545/';

  final String _privateKey =
      'd896ccf27953ac671255762946cfbcdc45872bdbef71ab37b895ed8f964044d2';

  String? _abiCode;

  EthereumAddress? _contractAddress;

  EthereumAddress? _ownAddress;

  Web3Client? _client;

  Credentials? _credentials;

  DeployedContract? _contract;

  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createTask;
  ContractEvent? _taskCreatedEvent;

  TodoListModel() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString('src/abis/TodoList.json');

    var jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);

    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = await _client!.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, 'TodoList'), _contractAddress!);

    _taskCount = _contract!.function('taskCount');
    _createTask = _contract!.function('createTask');
    _todos = _contract!.function('todos');
    _taskCreatedEvent = _contract!.event('TaskCreated');

    getTodos();

    // print(await _client!.call(contract: _contract!, function: _taskCount!, params: []));
  }

  getTodos() async {
    List totalTasksList = await _client!
        .call(contract: _contract!, function: _taskCount!, params: []);

    BigInt totalTasks = totalTasksList[0];
    taskCount = totalTasks.toInt();

    print('totalTasksList: $totalTasksList');
    print('totalTasks: $totalTasks');

    todo.clear();

    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await _client!.call(
          contract: _contract!, function: _todos!, params: [BigInt.from(i)]);

      todo.add(Task(taskName: temp[0], isCompleted: temp[1]));
    }

    print('todo: $todo');
    loading = false;

    notifyListeners();
  }

  addTask(String taskNameData) async {
    loading = true;

    notifyListeners();

    _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _contract!,
          function: _createTask!,
          parameters: [taskNameData],
        ));

    getTodos();
  }
}

class Task {
  String? taskName;
  bool? isCompleted;

  Task({this.taskName, this.isCompleted});
}
