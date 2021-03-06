var SongItem = React.createClass({
  mixins: [ReactRouter.History],
  showUser: function(){
    this.history.pushState(null,"users/" + this.props.song.user_id);
  },

  showSong: function(){
    this.history.pushState(null,"songs/" + this.props.song.id);
  },

  playSong: function(){
    window.CURRENT_PLAYING=true;
      ApiUtil.updateCurrentSong(this.props.song);
  },

  _submitted: function(){
    if(this.props.submitted){
      return<p>By:<a onClick={this.showUser}>{this.props.song.user.username}</a></p>;
    }
  },

  render: function(){
      return (
        <li className="SongItem">
          <img onClick={this.showSong} src={this.props.song.img_url} alt="songIcon" height="100" width="100"/>
          <p userId={this.props.song.user_id}>{this.props.song.title}</p>
          {this._submitted()}
          <br/>
          <LikeUnlike likeCount={this.props.song.likeCount}
            song={this.props.song}
            liked={this.props.song.current_user_likes}/>
          <button onClick={this.playSong}>play</button>
        </li>
      );
  }
});
