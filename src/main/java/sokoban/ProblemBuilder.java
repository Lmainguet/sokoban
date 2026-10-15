package sokoban;

import fr.uga.pddl4j.heuristics.state.StateHeuristic;
import fr.uga.pddl4j.planners.InvalidConfigurationException;
import fr.uga.pddl4j.planners.LogLevel;
import fr.uga.pddl4j.planners.Planner;
import fr.uga.pddl4j.planners.PlannerConfiguration;
import fr.uga.pddl4j.planners.statespace.HSP;
import fr.uga.pddl4j.problem.operator.Action;


import java.io.BufferedWriter;
import java.io.PrintWriter;
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

public class ProblemBuilder {
/**
 * 
 * @param jsonName
 * @throws FileNotFoundException
 * @throws IOException
 * @throws ParseException
 * @throws InvalidConfigurationException 
 */
	public static void problemBuild(String jsonName, int level) throws Exception {
		String[] grid = jsonToStringArray(jsonName);
		int height = grid.length;
        int width = grid[0].length();
		PrintWriter writer = new PrintWriter("src/main/java/sokoban/pddl/problem" + level + ".pddl");
		writer.println("(define (problem Sokoban" + level + ")");
        writer.println("(:domain robot-monde)");

        // OBJETS
        writer.println("(:objects");
        writer.println("  r1 - robot");

        writer.print("  ");
        for (int i = 1; i <= 20; i++) writer.print("b" + i + " ");
        writer.println("- box");

        writer.print("  ");
        for (int i = 1; i <= height * width; i++) writer.print("c" + i + " ");
        writer.println(" - cell)");
        writer.println();

        // INIT
        writer.println("(:init");
		int boxCount = 1;

		for (int r = 0; r < height; r++) {
			for (int c = 0; c < width; c++) {

				char ch = grid[r].charAt(c);
				int id = r * width + c + 1;
				String cell = "c" + id;

				switch (ch) {
					case '#':
						writer.println("  (wall " + cell + ")");
						break;

					case '.':
						writer.println("  (goal " + cell + ")");
						writer.println("  (free " + cell + ")");
						break;

					case '@':
						writer.println("  (at-robot " + cell + ")");
						writer.println("  (free " + cell + ")");
						break;

					case '$':
						writer.println("  (at-box b" + boxCount + " " + cell + ")");
						boxCount++;
						break;

					case '*':
						writer.println("  (at-box b" + boxCount + " " + cell + ")");
						writer.println("  (goal " + cell + ")");
						boxCount++;
						break;

					case ' ':
						// espace intérieur = free
						writer.println("  (free " + cell + ")");
						break;
					
					default :	
						// espace ajouté pour compléter = wall
						writer.println("  (wall " + cell + ")");
						break;
					
				}
			}
		}

		// 3. Adjacences
		for (int r = 0; r <height; r++) {
			for (int c = 0; c < width; c++) {

				int id = r * width + c + 1;
				String cell = "c" + id;

				if (c < width-1) {
					writer.println("  (dir-right c" + id + " c" + (id + 1) + ")");
					writer.println("  (dir-left c" + (id + 1) + " c" + id + ")");

					writer.println("  (adjacent c" + id + " c" + (id + 1) + ")");
					writer.println("  (adjacent c" + (id + 1) + " c" + id + ")");
				}
				if (r < height-1) {
					writer.println("  (dir-down c" + id + " c" + (id + width) + ")");
					writer.println("  (dir-up c" + (id + width) + " c" + id + ")");

					writer.println("  (adjacent c" + id + " c" + (id + width) + ")");
					writer.println("  (adjacent c" + (id + width) + " c" + id + ")");
				}
			}
		}

		writer.println(")");

		// 4. GOAL
		writer.println("(:goal (and");

		// toutes les cases avec un goal ou un * dans la grille
		boxCount = 1;

		for (int r = 0; r < height; r++) {
			for (int c = 0; c < width; c++) {

					char ch = grid[r].charAt(c);
					int id = r * width + c + 1;

					if (ch == '.' || ch == '*') {
						writer.println("  (at-box b" + boxCount + " c" + id + ")");
						boxCount++;
					}
				}
			}

		writer.println("))");
		writer.println(")");
		writer.close();
	}

	/**
	 * 
	 * @param jsonName
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws ParseException
	 */
	public static String[] jsonToStringArray(String jsonName)
        throws FileNotFoundException, IOException, ParseException {

		Object jsonObj = new JSONParser().parse(new FileReader("config/" +jsonName));
		JSONObject json = (JSONObject) jsonObj;

		String level = (String) json.get("testIn");
		System.out.println("Le niveau choisi :\n" + level);

		// Normalise les retours Windows
		level = level.replace("\r", "");

		// Découpage propre
		String[] lines = level.split("\n");

		return lines;
	}
}