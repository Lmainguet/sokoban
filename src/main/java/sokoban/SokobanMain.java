package sokoban;
import com.codingame.gameengine.runner.SoloGameRunner;
import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.LogLevel;
import fr.uga.pddl4j.planners.Planner;
import fr.uga.pddl4j.planners.PlannerConfiguration;
import fr.uga.pddl4j.planners.statespace.HSP;
import fr.uga.pddl4j.problem.operator.Action;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.json.simple.JSONObject;


public class SokobanMain {
    public static void main(String[] args) {
        System.out.println("PDDL4J est accessible !");
        
        try {
            ProblemBuilder.problemBuild("test21.json", 21);
            PlannerConfiguration config = HSP.getDefaultConfiguration();
            config.setProperty(HSP.DOMAIN_SETTING, "src/main/java/sokoban/pddl/domain.pddl");
            config.setProperty(HSP.PROBLEM_SETTING, "src/main/java/sokoban/pddl/problem21.pddl");
            config.setProperty(HSP.TIME_OUT_SETTING, 1000);

            Planner planner = Planner.getInstance(Planner.Name.HSP, config);
            List<Action> plan = planner.solve().actions();

            System.out.println("Plan trouvé : " + plan);
            System.out.println("Nombre d'actions : " + plan.size());
        } catch (Exception e) {
            e.printStackTrace();
        }
        SoloGameRunner gameRunner = new SoloGameRunner();
        gameRunner.setAgent(Agent.class);
        gameRunner.setTestCase("test21.json");
        gameRunner.start();
    }
}



