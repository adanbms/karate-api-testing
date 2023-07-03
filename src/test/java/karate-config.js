function fn() {
  var env = karate.env; // get system property 'karate.env'
                        // comes from the command line -Dkarate.env="value"
  karate.log('karate.env system property was:', env);

  if (!env) {
    env = 'dev';
  }
 
  var config = {
    conduitApiUrl: 'https://api.realworld.io/api',
    userEmail: '',
    userPass: ''
  };

  if (env == 'dev') {
    config.userEmail = 'bmerino@test.com';
    config.userPass = 'bmerino1234';
  } else if (env == 'sit') {
    config.userEmail = 'karate@test.com';
    config.userPass = 'karate123';
  }

  var authorizationToken = karate.callSingle('classpath:helpers/GetAuthToken.feature', config).authToken;
  karate.configure('headers', {authorization: 'Token ' + authorizationToken})

  return config;
}