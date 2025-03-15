abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();
}
