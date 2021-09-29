import 'package:on_audio_query/on_audio_query.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherSong();
  Future<List<Map<String, String>>> getAllSongs();
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length = 3}) async {
    return List.generate(length, (index) => _nextSong());
  }


  @override
  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = 0;
  static const _maxSongNumber = 16;

  Map<String, String> _nextSong() {
    _songIndex = (_songIndex % _maxSongNumber) + 1;
    return {
      'id': _songIndex.toString().padLeft(3, '0'),
      'title': 'Song $_songIndex',
      'album': 'SoundHelix',
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
    };
  }
  Map<String, String> allSong(SongModel songModel) {
    return {
      'id': songModel.id.toString(),
      'title': 'Song'+ songModel.title,
      'album': 'SoundHelix',
      'url':songModel.uri.toString(),
    };
  }


  Future<List<SongModel>> getSongs(
      {SongSortType? sortType, OrderType? orderType}) async {
    return OnAudioQuery().querySongs(
      sortType: sortType ?? SongSortType.DATA_ADDED,
      orderType: orderType ?? OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
    );
  }
  @override
  Future<List<Map<String, String>>> getAllSongs()async {

    final List<SongModel> temp = await getSongs();

    List<SongModel> _cachedSongs = temp.where((i) => (i.duration ?? 60000) > 1000 * 60).toList();
    return List.generate(_cachedSongs.length, (index) => allSong(_cachedSongs[index]));

  }
}
