package sokoban;

import java.util.Scanner;

public class Agent {
    //private static final String PROBLEM_FILE = "sokoban_pddl/sokoban_problem.pddl";

    public static void main(String[] args) {
        //Scanner input = new Scanner(System.in);
        //convertCurrentLevelToPDDLProblem(input);
        String solution = "DUU";
        for (char c : solution.toCharArray()) System.out.println(c);
    }


    /*public static void convertCurrentLevelToPDDLProblem(Scanner input) {

        // First line: dimensions and number of boxes
        int width = input.nextInt();
        int height = input.nextInt();
        int boxCount = input.nextInt();
        input.nextLine(); // Consume the remaining newline
        System.err.printf("[INPUT] width=%d height=%d boxes=%d%n", width, height, boxCount);

        // Complete static map: '#' = wall, '*' = goal, '.' = floor
        char[][] map = new char[height][];
        for (int y = 0; y < height; y++) {
        map[y] = input.nextLine().toCharArray();
        System.err.printf("[INPUT] row %02d |%s|%n", y, new String(map[y]));
    }

    // Initial player position
    int playerX = input.nextInt();
    int playerY = input.nextInt();
    System.err.printf("[INPUT] player x=%d y=%d%n", playerX, playerY);

    // Initial box positions
    int[][] boxes = new int[boxCount][2];
    for (int i = 0; i < boxCount; i++) {
       boxes[i][0] = input.nextInt(); // x
       boxes[i][1] = input.nextInt(); // y
       System.err.printf("[INPUT] box %d x=%d y=%d%n", i, boxes[i][0], boxes[i][1]);
    }

    createPDDLProblemFile(PROBLEM_FILE, width, height, boxCount, map, playerX, playerY, boxes);
    return;}*/
}
