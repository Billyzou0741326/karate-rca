# Karate RCA

**Update**: For workaround, see the [workaround section](#workaround).

A small reproducible setup of karate, showing the combination of `jar` cli and `karate.callSingle()` in `karate-config.js`
does not work. On the other hand, `mvn test` executes successfully.

The `jar` cli invocation would fail with:

```
org.graalvm.polyglot.PolyglotException: not found: auth/oauth2.feature
- com.intuit.karate.resource.ResourceUtils.getResource(ResourceUtils.java:126)
- com.intuit.karate.core.ScenarioFileReader.toResource(ScenarioFileReader.java:129)
- com.intuit.karate.core.ScenarioFileReader.readFile(ScenarioFileReader.java:64)
- com.intuit.karate.core.ScenarioBridge.read(ScenarioBridge.java:731)
- com.intuit.karate.core.ScenarioBridge.callSingle(ScenarioBridge.java:229)
- <js>.fn(Unnamed:12)
```

The exact error may look a bit different, but should be somewhere along the lines of `file not found`.


## Docker

The example is reproducible via the `Dockerfile`.

To build:

```
docker build . -t karate-rca
```

And then run by:

```
docker run --rm -it karate-rca
```

The output should be errors, and the error due to the  `karate.callSingle()` can't find the specified file (`auth.oauth2.feature`).

For comparison, without `karate.callSingle()` (env `prod`), it's successful. To execute a successful docker run:

```
docker run --rm -it karate-rca -e prod
```


## Maven

Both cases are successful. There are no issues with `karate.callSingle()` when the tests are run by maven.


## Workaround

Section added after reading into the implementation of karate's `ResourceUtils` and having done some research on `jar`s
and `classpath:` prefix.

### The issue

The `karate.jar` (or any jar, in that regard) is not able to resolve `classpath:<filepath>` where `<filepath>` locates
outside the jar.

If any `.feature` file or `karate-config-<env>.js` file tries to specify a `classpath:` location, `karate.jar` will throw
the "not found" error.


### The solution

While this may not be the best solution, a workaround is to add the file(s) that are referenced with `classpath:` prefix
to the `karate.jar`. In this case, add everything under `src/test/resources` to the jar:

```shell
cd src/test/resources
jar uf /tmp/karate.jar .
```

However, this approach is not without limitations. It assumes that you have access to a jdk (the `jar` command), and that
you have write access to the `karate.jar`. Both of these assumptions are non-issues in a Docker build process.
