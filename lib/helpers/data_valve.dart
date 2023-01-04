//# the purpose of these classes is to handle the operation of having a large data, but you want to get batch by batch and
//# you want to keep the current position of the data you have or the last index you have
//# and when asking for the next batch you just want to start from the next index after the last index you have + the batch size
//# this way you will keep your UI clean and smooth rather than loading all data to the UI at once

class DataKey {
  final String key;
  List<dynamic> data;

  DataKey({
    required this.key,
    required this.data,
  });
}

class DataPositionKey {
  final String key;
  int position;

  DataPositionKey({
    required this.key,
    required this.position,
  });
}

class DataValveState {
  int batchSize = 10;
  List<DataKey> allDataLists = [];
  List<DataPositionKey> positions = [];

  void setBatchSize(int b) {
    batchSize = b;
  }

  //? to subscribe for a new data collection
  void addData(DataKey dataKey) {
    if (allDataLists.any((element) => element.key == dataKey.key)) {
      throw Exception('Data valve key already exists');
    }
    allDataLists.add(dataKey);
    // creating a new position key and add it to the list
    DataPositionKey dataPositionKey = DataPositionKey(
      key: dataKey.key,
      position: 0,
    );
    positions.add(dataPositionKey);
  }

  //? to get the current position of the data you have( the last index of the batch you have)
  int getKeyCurrentPosition(String dataKey) {
    return positions.firstWhere((element) => element.key == dataKey).position;
  }

  //? update current position
  void _updateCurrentPosition(String dataKey, int newPosition) {
    int index = positions.indexWhere((element) => element.key == dataKey);
    DataPositionKey newDataPosition = DataPositionKey(
      key: dataKey,
      position: newPosition,
    );
    positions[index] = newDataPosition;
  }

  //? to get the next batch
  List<dynamic> getNextBatch(String dataKey, [int? newBatch]) {
    // getting the data
    int currentPosition = getKeyCurrentPosition(dataKey);
    int newCurrentPosition = (currentPosition + (newBatch ?? batchSize));
    DataKey dataObject =
        allDataLists.firstWhere((element) => element.key == dataKey);
    int dataLength = dataObject.data.length;
    newCurrentPosition = newCurrentPosition > (dataLength - 1)
        ? newCurrentPosition = dataLength
        : newCurrentPosition;
    // updating the current position
    _updateCurrentPosition(dataKey, newCurrentPosition);
    return dataObject.data.sublist(currentPosition, newCurrentPosition);
  }

  //? get next batch with the whole data before
  List<dynamic> getToNextBatch(String dataKey) {
    // getting the data
    int currentPosition = getKeyCurrentPosition(dataKey);
    int newCurrentPosition = (currentPosition + batchSize) + 1;
    DataKey dataObject = allDataLists.firstWhere((element) => false);
    // updating the current position
    _updateCurrentPosition(dataKey, newCurrentPosition);
    return dataObject.data.sublist(0, newCurrentPosition);
  }
}
