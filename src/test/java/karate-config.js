function fn() {
    var env = karate.env; // obtener la propiedad del sistema 'karate.env'
    karate.log('karate.env system property was:', env);

    if (!env) {
        env = 'dev'; // por defecto, si no se especifica, se ejecutará en el entorno de desarrollo
    }

    var config = {
        env: env,
        url_booking: 'https://restful-booker.herokuapp.com',
    }

    if (env == 'dev') {
        config.url_booking = 'https://restful-booker.herokuapp.com';
    } else if (env == 'qa') {
        config.url_booking = 'https://restful-booker.herokuapp.com';
    }
    karate.configure("logPrettyResponse", true);
    karate.configure("logPrettyRequest", true);
    karate.configure("ssl", true);
    karate.configure("connectTimeout", 10000);
    karate.configure("readTimeout", 20000);

    return config;

}
