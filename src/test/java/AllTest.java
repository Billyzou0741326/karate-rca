import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class AllTest {

    @Test
    public void allTests() {
        Results results = Runner.path("classpath:.").parallel(12);
        Assertions.assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
