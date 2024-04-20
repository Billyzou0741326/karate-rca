function fn() {
    karate.configure('retry', { interval: 0 });

    let accessToken = '';

    if (karate.env === 'prod') {
        // Happy path
        accessToken = 'mock oauth2 access token';
    }
    if (karate.env !== 'prod') {
        // ERROR: this doesn't work when running as standalone jar
        const result = karate.callSingle('classpath:auth/oauth2.feature', {});
        accessToken = result.access_token;
    }

    return {
        access_token: accessToken,
    };
}
