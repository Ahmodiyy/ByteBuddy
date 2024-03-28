import 'package:envied/envied.dart';

part 'Env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(obfuscate: true, varName: 'payStackTestPublicKey')
  static String payStackTestPublicKey = _Env.payStackTestPublicKey;
  @EnviedField(obfuscate: true, varName: 'payStackTestSecretKey')
  static String payStackTestSecretKey = _Env.payStackTestSecretKey;
  @EnviedField(obfuscate: true, varName: 'payStackTestPublicKey')
  static String payStackLivePublicKey = _Env.payStackLivePublicKey;
  @EnviedField(obfuscate: true, varName: 'payStackTestSecretKey')
  static String payStackLiveSecretKey = _Env.payStackLiveSecretKey;
  @EnviedField(obfuscate: true, varName: 'getDataPlanEndpoint')
  static String getDataPlanEndpoint = _Env.getDataPlanEndpoint;
  @EnviedField(obfuscate: true, varName: 'buyDataPlanEndpoint')
  static String buyDataPlanEndpoint = _Env.buyDataPlanEndpoint;
}
