package sokoban;

import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.planners.statespace.HSP;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import java.util.List;
import java.io.IOException;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import java.io.FileReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

public class ProblemBuilder {

    public static List<String> solve(int width, int height, char[][] map, int playerX, int playerY,
                                      int[][] boxes) throws IOException, ProblemNotSupportedException {
        Path domainFile = Files.createTempFile("sokoban-domain-", ".pddl");
        Path problemFile = Files.createTempFile("sokoban-problem-", ".pddl");
        try {
            try (InputStream domain = Agent.class.getResourceAsStream("/sokoban/domain.pddl")) {
                if (domain == null) {
                    throw new IllegalStateException("PDDL domain resource /sokoban/domain.pddl was not found");
                }
                Files.copy(domain, domainFile, StandardCopyOption.REPLACE_EXISTING);
            }
            String problem = createProblem(width, height, map, playerX, playerY, boxes);
            Files.write(problemFile, problem.getBytes(StandardCharsets.UTF_8));

            HSP planner = new HSP();
            planner.setTimeout(8);
            DefaultParsedProblem parsed = planner.parse(domainFile.toString(), problemFile.toString());
            if (parsed == null) {
                planner.getParserErrorManager().printAll();
                throw new IllegalStateException("PDDL4J could not parse the Sokoban domain and problem");
            }
            Problem instantiated = planner.instantiate(parsed);
            Plan result = planner.solve(instantiated);
            if (result == null) {
                throw new IllegalStateException("PDDL4J did not find a plan for this Sokoban level");
            }

            List<String> moves = new ArrayList<>();
            for (Action action : result.actions()) {
                moves.add(toGameMove(instantiated.toString(action)));
            }
            if (moves.isEmpty()) {
                return firstLegalMove(width, height, map, playerX, playerY, boxes);
            }
            System.out.println("===== PLAN PDDL =====");

            int step = 1;

            for (Action action : result.actions()) {

                String a = instantiated.toString(action);
                System.out.println(step + " : " + a);
                step++;
            }

            System.out.println("=====================");
            System.err.println("PDDL4J found a plan with " + moves.size() + " moves.");
            return moves;
        } finally {
            Files.deleteIfExists(domainFile);
            Files.deleteIfExists(problemFile);
        }
    }

    private static String position(int x, int y) {
        return "p" + x + "_" + y;
    }

    private static String toGameMove(String plannedAction) {
        Matcher positions = Pattern.compile("p(\\d+)_(\\d+)").matcher(plannedAction);
        if (!positions.find()) {
            throw new IllegalStateException("Could not read the origin position from PDDL action: " + plannedAction);
        }
        int fromX = Integer.parseInt(positions.group(1));
        int fromY = Integer.parseInt(positions.group(2));
        if (!positions.find()) {
            throw new IllegalStateException("Could not read the destination position from PDDL action: " + plannedAction);
        }
        int toX = Integer.parseInt(positions.group(1));
        int toY = Integer.parseInt(positions.group(2));

        if (toX == fromX && toY == fromY - 1) return "U";
        if (toX == fromX + 1 && toY == fromY) return "R";
        if (toX == fromX && toY == fromY + 1) return "D";
        if (toX == fromX - 1 && toY == fromY) return "L";
        throw new IllegalStateException("PDDL action is not a one-cell move: " + plannedAction);
    }

    private static void appendObjects(StringBuilder pddl, List<String> objects, String type) {
        for (String object : objects) {
            pddl.append(object).append(' ');
        }
        pddl.append("- ").append(type);
    }

    

    private static List<String> firstLegalMove(int width, int height, char[][] map,
                                               int playerX, int playerY, int[][] boxes) {
        boolean[][] occupied = new boolean[height][width];
        for (int[] box : boxes) {
            occupied[box[1]][box[0]] = true;
        }
        int[][] directions = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
        String[] moves = {"U", "R", "D", "L"};
        for (int i = 0; i < directions.length; i++) {
            int x = playerX + directions[i][0];
            int y = playerY + directions[i][1];
            if (isWalkable(map, width, height, x, y) && !occupied[y][x]) {
                List<String> move = new ArrayList<>();
                move.add(moves[i]);
                return move;
            }
        }
        throw new IllegalStateException("The level is already solved but the player has no legal move");
    }

    private static boolean isWalkable(char[][] map, int width, int height, int x, int y) {
        return x >= 0 && x < width && y >= 0 && y < height && map[y][x] != '#';
    }

    private static void addRelations(StringBuilder initial, char[][] map, int width, int height, int x, int y) {
        int[][] directions = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
        for (int[] direction : directions) {
            int middleX = x + direction[0];
            int middleY = y + direction[1];
            if (!isWalkable(map, width, height, middleX, middleY)) {
                continue;
            }
            initial.append("    (adjacent ").append(position(x, y)).append(' ')
                    .append(position(middleX, middleY)).append(")\n");

            int toX = middleX + direction[0];
            int toY = middleY + direction[1];
            if (isWalkable(map, width, height, toX, toY)) {
                initial.append("    (straight ").append(position(x, y)).append(' ')
                        .append(position(middleX, middleY)).append(' ')
                        .append(position(toX, toY)).append(")\n");
            }
        }
    }


    private static String createProblem(int width, int height, char[][] map, int playerX, int playerY, int[][] boxes) {
        if (playerX < 0 || playerX >= width || playerY < 0 || playerY >= height
                || map[playerY][playerX] == '#') {
            throw new IllegalArgumentException("Player is outside the walkable map");
        }

        boolean[][] occupied = new boolean[height][width];
        occupied[playerY][playerX] = true;
        for (int[] box : boxes) {
            int x = box[0];
            int y = box[1];
            if (x < 0 || x >= width || y < 0 || y >= height || map[y][x] == '#') {
                throw new IllegalArgumentException("Box is outside the walkable map: " + x + " " + y);
            }
            if (occupied[y][x]) {
                throw new IllegalArgumentException("Two objects occupy the same position: " + x + " " + y);
            }
            occupied[y][x] = true;
        }

        List<String> positions = new ArrayList<>();
        List<String> goals = new ArrayList<>();
        StringBuilder initial = new StringBuilder();
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                if (map[y][x] == '#') {
                    continue;
                }
                String position = position(x, y);
                positions.add(position);
                if (map[y][x] == '*') {
                    goals.add(position);
                    initial.append("    (goal ").append(position).append(")\n");
                } else {
                    initial.append("    (not-goal ").append(position).append(")\n");
                }
                if (!occupied[y][x]) {
                    initial.append("    (free ").append(position).append(")\n");
                }
                addRelations(initial, map, width, height, x, y);
            }
        }
        if (goals.size() != boxes.length) {
            throw new IllegalArgumentException("Level has " + boxes.length + " boxes but " + goals.size() + " goals");
        }

        initial.append("    (at-player ").append(position(playerX, playerY)).append(")\n");
        for (int i = 0; i < boxes.length; i++) {
            initial.append("    (at-box b").append(i).append(' ')
                    .append(position(boxes[i][0], boxes[i][1])).append(")\n");
            if (map[boxes[i][1]][boxes[i][0]] == '*') {
                initial.append("    (solved b").append(i).append(")\n");
            }
        }

        StringBuilder pddl = new StringBuilder();
        pddl.append("(define (problem sokoban-level)\n")
                .append("  (:domain sokoban)\n")
                .append("  (:objects\n    ");
        appendObjects(pddl, positions, "position");
        if (boxes.length > 0) {
            pddl.append("\n    ");
            for (int i = 0; i < boxes.length; i++) {
                if (i > 0) {
                    pddl.append(' ');
                }
                pddl.append('b').append(i);
            }
            pddl.append(" - box");
        }
        pddl.append("\n  )\n  (:init\n")
                .append(initial)
                .append("  )\n  (:goal (and\n");
        for (int i = 0; i < boxes.length; i++) {
            pddl.append("    (solved b").append(i).append(")\n");
        }
        pddl.append("  ))\n)\n");
        return pddl.toString();
    }
}