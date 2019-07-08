class SpotifyService
  def initialize
    @client = SpotifyClient.new
  end

  def update_artists(artists)
    artists.each { |artist| update_artist(artist) }
  end

  def update_artist(artist)
    data = @client.get_artist_data(artist.name)
    if data
      artist.update(genres: data.genres,
                    popularity: data.popularity,
                    spotify_url: data.external_urls["spotify"],
                    spotify_id: data.id)
      create_albums(artist, data.albums)
    end
  end

  def create_albums(artist, albums)
   albums.each do |data_album|
      album = Album.create!(artist_id: artist.id,
                            name: data_album.name,
                            spotify_url: data_album.external_urls["spotify"],
                            total_tracks: data_album.tracks.count,
                            spotify_id: data_album.id )
      create_songs(album, data_album.tracks)
    end
  end

  def create_songs(album, tracks)
    tracks.each do |track|
      album.songs.create!(name: track.name,
                         spotify_url: track.external_urls["spotify"],
                         preview_url: track.preview_url,
                         duration_ms: track.duration_ms,
                         explicit: track.explicit,
                         spotify_id: track.id)
    end
  end
end