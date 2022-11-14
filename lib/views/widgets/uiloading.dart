part of 'widgets.dart';

class UiLoading{
  
  static Container loading(){
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: const SpinKitFadingCircle(
        size: 50,
        color: Color(0xFFFF5555),
      ),
    );
  }

  static Container loadingBlock(){
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Color.fromARGB(70, 172, 172, 172),
      child: const SpinKitFadingCircle(
        size: 50,
        color: Color(0xFFFF5555),
      ),
    );
  }

  static Container loadingDD(){
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      color: Colors.transparent,
      child: const SpinKitFadingCircle(
        size: 30,
        color: Color.fromARGB(255, 117, 18, 18),
      ),
    );
  }

}