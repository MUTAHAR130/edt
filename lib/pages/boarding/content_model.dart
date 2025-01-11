class OnBoardingModel{
  String image;
  String title;
  String description;
  OnBoardingModel({required this.image,required this.title,required this.description});
}
List<OnBoardingModel> contents=[
  OnBoardingModel(
    title: 'Anywhere you are',
    image: 'assets/images/boarding1.png',
    description: 'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.'
  ),
  OnBoardingModel(
    title: 'At anytime',
    image: 'assets/images/boarding2.png',
    description: 'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.'
  ),
  OnBoardingModel(
    title: 'Book your car',
    image: 'assets/images/boarding3.png',
    description: 'Sell houses easily with the help of Listenoryx and to make this line big I am writing more..'
  )
];