class HomePageEvent {

}

class LoadHomePageEvent extends HomePageEvent {

}

class UpdateProgressEvent extends HomePageEvent {
  final double progress;

  UpdateProgressEvent({
    this.progress = 0.0,

  });
}