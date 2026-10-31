package sokoban;

import fr.uga.pddl4j.planners.ProblemNotSupportedException;

import java.io.IOException;
import java.util.List;
import java.util.Scanner;


public class Agent {

    public static void main(String[] args) throws IOException, ProblemNotSupportedException {
        Scanner input = new Scanner(System.in);
        if (!input.hasNextInt()) {
            return;
        }

        int width = input.nextInt();
        int height = input.nextInt();
        int boxCount = input.nextInt();
        input.nextLine();

        char[][] map = new char[height][width];
        for (int y = 0; y < height; y++) {
            String row = input.nextLine();
            if (row.length() != width) {
                throw new IllegalArgumentException("Expected map row of width " + width + ", got " + row.length());
            }
            map[y] = row.toCharArray();
        }

        int playerX = input.nextInt();
        int playerY = input.nextInt();
        int[][] boxes = new int[boxCount][2];
        for (int i = 0; i < boxCount; i++) {
            boxes[i][0] = input.nextInt();
            boxes[i][1] = input.nextInt();
        }
        input.nextLine();

        List<String> plan = ProblemBuilder.solve(
                                                width,
                                                height,
                                                map,
                                                playerX,
                                                playerY,
                                                boxes
                                            );
        int nextAction = 0;
        while (true) {
            if (nextAction >= plan.size()) {
                throw new IllegalStateException("The planner's action sequence ended before the game was solved");
            }
            System.out.println(plan.get(nextAction++));
            System.out.flush();

            if (!input.hasNextInt()) {
                return;
            }
            input.nextInt();
            input.nextInt();
            for (int i = 0; i < boxCount; i++) {
                input.nextInt();
                input.nextInt();
            }
            input.nextLine();
        }
    }
    
}
